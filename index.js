// Cloud Functions for Mokhtafoun
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import fetch from 'node-fetch';
import * as cheerio from 'cheerio';
import FormData from 'form-data';

admin.initializeApp();

const AZURE_TEXT_KEY = process.env.AZURE_TEXT_KEY;
const AZURE_TEXT_ENDPOINT = process.env.AZURE_TEXT_ENDPOINT;
const AZURE_TRANSLATOR_KEY = process.env.AZURE_TRANSLATOR_KEY;
const AZURE_TRANSLATOR_ENDPOINT = process.env.AZURE_TRANSLATOR_ENDPOINT;
const AZURE_SPEECH_KEY = process.env.AZURE_SPEECH_KEY;
const AZURE_SPEECH_REGION = process.env.AZURE_SPEECH_REGION;

// Summarize feedback (fallback simple extract)
export const summarizeFeedback = functions.https.onRequest(async (req, res) => {
  try {
    const text = (req.body?.text || '').toString();
    if (!text) return res.status(400).json({error:'text required'});
    if (!AZURE_TEXT_KEY || !AZURE_TEXT_ENDPOINT) {
      const sentences = text.split(/(?<=[.!?؟])\s+/).slice(0,3).join(' ');
      return res.json({summary: sentences, provider:'fallback'});
    }
    const sentences = text.split(/(?<=[.!?؟])\s+/).slice(0,3).join(' ');
    return res.json({summary: sentences, provider:'azure(placeholder)'});
  } catch(e){ return res.status(500).json({error:e.message}); }
});

// Translate
export const translateText = functions.https.onRequest(async (req,res)=>{
  try {
    const text = (req.body?.text || '').toString();
    const to = (req.body?.to || 'en').toString();
    if (!text) return res.status(400).json({error:'text required'});
    if (!AZURE_TRANSLATOR_KEY || !AZURE_TRANSLATOR_ENDPOINT) {
      return res.json({translated: text, provider:'echo'});
    }
    const r = await fetch(`${AZURE_TRANSLATOR_ENDPOINT}/translate?api-version=3.0&to=${encodeURIComponent(to)}`, {
      method: 'POST',
      headers: {'Ocp-Apim-Subscription-Key': AZURE_TRANSLATOR_KEY, 'Content-Type': 'application/json'},
      body: JSON.stringify([{Text:text}])
    });
    const j = await r.json();
    const translated = j?.[0]?.translations?.[0]?.text ?? text;
    return res.json({translated, provider:'azure'});
  } catch(e){ return res.status(500).json({error:e.message}); }
});

// Simple moderation
const BAD = ['fuck','shit','bitch'];
export const moderateText = functions.https.onRequest(async (req,res)=>{
  try {
    const text = (req.body?.text || '').toString().toLowerCase();
    const found = BAD.filter(w=> text.includes(w));
    return res.json({ok: found.length===0, banned: found});
  } catch(e){ return res.status(500).json({error:e.message}); }
});

// OG importer
export const ogImport = functions.https.onRequest(async (req,res)=>{
  try {
    const url = (req.body?.url || '').toString();
    if (!url) return res.status(400).json({error:'url required'});
    const r = await fetch(url, {headers:{'User-Agent':'Mozilla/5.0'}});
    if (!r.ok) return res.status(400).json({error:'fetch failed'});
    const html = await r.text();
    const $ = cheerio.load(html);
    const og = (p)=> $(`meta[property='og:${p}']`).attr('content') || '';
    const data = { title: og('title') || ($('title').text() || '').trim(), description: og('description') || '', image: og('image') || '', site_name: og('site_name') || '', url };
    return res.json(data);
  } catch(e){ return res.status(500).json({error:e.message}); }
});

// Speech-to-text (requires Azure keys)
export const transcribeAudio = functions.https.onRequest(async (req,res)=>{
  try {
    if (!process.env.AZURE_SPEECH_KEY || !process.env.AZURE_SPEECH_REGION) return res.status(501).json({error:'AZURE_SPEECH not configured'});
    const audioUrl = (req.body?.audioUrl || '').toString();
    if (!audioUrl) return res.status(400).json({error:'audioUrl required'});
    const tokenResp = await fetch(`https://${process.env.AZURE_SPEECH_REGION}.api.cognitive.microsoft.com/sts/v1.0/issueToken`, { method:'POST', headers:{'Ocp-Apim-Subscription-Key': process.env.AZURE_SPEECH_KEY}});
    const token = await tokenResp.text();
    const r = await fetch(`https://${process.env.AZURE_SPEECH_REGION}.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=ar-MA`, {
      method:'POST', headers:{'Authorization':`Bearer ${token}`, 'Content-Type':'audio/mpeg'},
      body: (await (await fetch(audioUrl)).arrayBuffer())
    });
    const j = await r.json();
    return res.json(j);
  } catch(e){ return res.status(500).json({error:e.message}); }
});
