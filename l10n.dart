import 'package:flutter/material.dart';
class L10n {
  static const supported = [Locale('ar'), Locale('fr'), Locale('en'), Locale('es')];
  static final _t = {
    'en': {
      'appTitle': 'Mokhtafoun','about':'About','contact':'Contact','license':'License',
      'cases': 'Cases', 'submit': 'Submit', 'success': 'Success', 'rewards': 'Rewards', 'admin': 'Admin',
      'unknown': 'Unknown', 'other': 'Other', 'police': 'Police Contacted?',
      'yes': 'Yes','no':'No','unsure':'Unsure',
      'cityArr': 'City / Arrondissement',
      'name':'Name','family':'Family contact','foundby':'Found/carer name','phone':'Phone',
      'age':'Age','height':'Height','eyes':'Eye colour','hair':'Hair','address':'Address','familyAddress':'Family address',
      'last':'Last seen / Found','photo':'Photo','audio':'Audio report','record':'Record','stop':'Stop','notes':'Notes',
      'submitBtn':'Submit','boost':'Boost (ad request)','reward':'Reward amount','currency':'Currency','rewardNotes':'Reward notes',
      'importUrl':'Import from URL','import':'Import','approve':'Approve','reject':'Reject','pending':'Pending approvals',
      'deleteReq':'Deletion requests','adReqs':'Ad requests','markReunited':'Mark Reunited','reunited':'Reunited bi fadli Lah',
      'successMsg':'Submitted for review. Thank you.',
    },
    'fr': {
      'appTitle': 'Mokhtafoun','about':'À propos','contact':'Contact','license':'Licence',
      'cases': 'Dossiers','submit':'Soumettre','success':'Réunions','rewards':'Récompenses','admin':'Admin',
      'unknown':'Inconnu','other':'Autre','police':'Police contactée ?','yes':'Oui','no':'Non','unsure':'Incertain',
      'cityArr':'Ville / Arrondissement','name':'Nom','family':'Contact famille','foundby':'Nom du déclarant','phone':'Téléphone',
      'age':'Âge','height':'Taille','eyes':'Couleur des yeux','hair':'Cheveux','address':'Adresse','familyAddress':'Adresse famille',
      'last':'Dernière fois vu / Trouvé','photo':'Photo','audio':'Audio','record':'Enregistrer','stop':'Arrêter','notes':'Notes',
      'submitBtn':'Envoyer','boost':'Booster (demande pub)','reward':'Récompense','currency':'Devise','rewardNotes':'Notes',
      'importUrl':'Importer depuis URL','import':'Importer','approve':'Approuver','reject':'Rejeter','pending':'En attente',
      'deleteReq':'Demandes de suppression','adReqs':'Demandes pub','markReunited':'Marquer réuni','reunited':'Réuni, alhamdulillah',
      'successMsg':'Envoyé pour révision. Merci.',
    },
    'ar': {
      'appTitle': 'مختفون','about':'حول التطبيق','contact':'اتصال','license':'الرخصة',
      'cases': 'البلاغات','submit':'إضافة بلاغ','success':'النجاحات','rewards':'النقاط','admin':'الإدارة',
      'unknown':'غير معروف','other':'أخرى','police':'هل تم إبلاغ الشرطة؟','yes':'نعم','no':'لا','unsure':'غير متأكد',
      'cityArr':'المدينة / المقاطعة','name':'الاسم','family':'اتصال العائلة','foundby':'اسم المُبلِّغ/الراعي','phone':'الهاتف',
      'age':'العمر','height':'الطول','eyes':'لون العينين','hair':'الشعر','address':'العنوان','familyAddress':'عنوان العائلة',
      'last':'آخر مكان شوهد/تم العثور عليه','photo':'صورة','audio':'تسجيل صوتي','record':'تسجيل','stop':'إيقاف','notes':'ملاحظات',
      'submitBtn':'إرسال','boost':'ترقية (طلب إعلان)','reward':'مكافأة','currency':'العملة','rewardNotes':'ملاحظات المكافأة',
      'importUrl':'استيراد من رابط','import':'استيراد','approve':'قبول','reject':'رفض','pending':'الطلبات المعلقة',
      'deleteReq':'طلبات حذف البيانات','adReqs':'طلبات الإعلانات','markReunited':'وَسْم كمُتَّحِد','reunited':'تم لمّ الشمل بفضل الله',
      'successMsg':'تم الإرسال للمراجعة. شكراً.',
    },
    'es': {
      'appTitle': 'Mokhtafoun','about':'Acerca de','contact':'Contacto','license':'Licencia',
      'cases':'Casos','submit':'Enviar','success':'Reencuentros','rewards':'Recompensas','admin':'Admin',
      'unknown':'Desconocido','other':'Otro','police':'¿Se avisó a la policía?','yes':'Sí','no':'No','unsure':'No seguro',
      'cityArr':'Ciudad / Distrito','name':'Nombre','family':'Contacto familiar','foundby':'Nombre del cuidador','phone':'Teléfono',
      'age':'Edad','height':'Altura','eyes':'Color de ojos','hair':'Cabello','address':'Dirección','familyAddress':'Dirección familiar',
      'last':'Visto por última vez / Hallado','photo':'Foto','audio':'Audio','record':'Grabar','stop':'Detener','notes':'Notas',
      'submitBtn':'Enviar','boost':'Impulsar (anuncio)','reward':'Recompensa','currency':'Moneda','rewardNotes':'Notas de recompensa',
      'importUrl':'Importar desde URL','import':'Importar','approve':'Aprobar','reject':'Rechazar','pending':'Pendientes',
      'deleteReq':'Solicitudes de borrado','adReqs':'Solicitudes de anuncios','markReunited':'Marcar reunificado','reunited':'Reunificado, alhamdulillah',
      'successMsg':'Enviado para revisión. Gracias.',
    },
  };
  static String t(BuildContext c, String k){final code=Localizations.localeOf(c).languageCode;return (_t[code]?[k]??_t['en']![k])??k;}
}
