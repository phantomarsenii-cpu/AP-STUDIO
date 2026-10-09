#!/usr/bin/env bash
# update_site-ap-studio.sh  (AP-STUDIO repo, run from its root)
# One script for the studio site:
#  1) ALWAYS: adds an Instagram button to the CONTACT block of index.html
#     (between TikTok and Telegram) -> https://www.instagram.com/apstudiomobile/
#  2) ONLY with the flag  --with-privacy : updates the WayArs privacy policy
#     (wayars/privacy/index.html, EN/PL/RU/UK, date October 8, 2026).
#     Use the flag together with the app release that carries the new in-app policy,
#     so the in-app text and the website text stay identical.
# Idempotent: safe to run again.
set -e
cd "$(dirname "$0")"
[ -f index.html ] || { echo "Run from the AP-STUDIO repo root (index.html not found)"; exit 1; }

python3 - <<'IGEOF'
import io
P = "index.html"
s = io.open(P, encoding="utf-8").read()
if "instagram.com/apstudiomobile" in s:
    print("already OK", P, "(Instagram button present)")
else:
    anchor = '}),v("a",{href:"https://t.me/ap_stud1o"'
    if s.count(anchor) != 1:
        raise SystemExit("anchor for the Telegram button found %d times (expected 1)" % s.count(anchor))
    btn = (
        '}),v("a",{href:"https://www.instagram.com/apstudiomobile/",target:"_blank",rel:"noopener noreferrer",'
        'className:"group w-full h-[56px] rounded-[16px] bg-[#121B36] border border-white/[0.08] text-white flex items-center '
        'justify-center gap-3 text-[15px] tracking-[-0.01em] active:scale-[0.98] transition-all hover:bg-[#172246] hover:border-white/[0.12]",'
        'style:{fontFamily:"Rajdhani, sans-serif",fontWeight:700},children:['
        'g("div",{className:"w-8 h-8 rounded-full border border-white/10 flex items-center justify-center",'
        'style:{background:"linear-gradient(45deg,#F9CE34,#EE2A7B,#6228D7)"},'
        'children:v("svg",{width:"16",height:"16",viewBox:"0 0 24 24",fill:"none",stroke:"white",strokeWidth:"1.8",'
        'children:[g("rect",{x:"3",y:"3",width:"18",height:"18",rx:"5"}),g("circle",{cx:"12",cy:"12",r:"4.2"}),'
        'g("circle",{cx:"17.3",cy:"6.7",r:"1",fill:"white",stroke:"none"})]})}),'
        '"Instagram",'
        'g("svg",{width:"14",height:"14",viewBox:"0 0 16 16",className:"opacity-40 group-hover:opacity-80 group-hover:translate-x-0.5 transition-all",'
        'children:g("path",{d:"M5 3 L11 8 L5 13",stroke:"currentColor",strokeWidth:"1.6",fill:"none",strokeLinecap:"round"})})]})'
    )
    s = s.replace(anchor, btn + ',v("a",{href:"https://t.me/ap_stud1o"', 1)
    io.open(P, "w", encoding="utf-8").write(s)
    print("updated", P, "(Instagram button added)")
IGEOF

if [ "$1" = "--with-privacy" ]; then
  [ -f wayars/privacy/index.html ] || { echo "wayars/privacy/index.html not found"; exit 1; }
python3 - <<'PYEOF'
import io
P = "wayars/privacy/index.html"
s = io.open(P, encoding="utf-8").read()

def rep(old, new):
    global s
    if new in s:
        return
    if s.count(old) != 1:
        raise SystemExit("%d matches for: %s" % (s.count(old), old[:60]))
    s = s.replace(old, new, 1)

def trial(h3, text):
    return '<div class="item"><h3>%s</h3><code>LOCAL_ONLY</code><p>%s</p></div>\n' % (h3, text)

# ---- EN
rep("<b>October 5, 2026</b>", "<b>October 8, 2026</b>")
rep("is not shared with third parties or used for advertising.",
    "is not shared with third parties or used for advertising. The service never taps, types or changes anything on the screen and is not used to record calls. Events from all other apps are ignored immediately: nothing from them is read or stored. Before the service can be enabled, the app shows a disclosure and asks for your consent, and you can turn it off at any time.")
rep("Notification access is used solely to detect new order offers while the app is running in background.",
    "Notification access is optional and is used solely to detect new order offers from the supported apps while the app is running in background. Other notifications are not read or stored.")
rep("calculated rates and verdict of each evaluated order",
    "calculated rates, estimated fuel cost, net profit and verdict of each evaluated order")
rep('<div class="item"><h3>Installed Apps List</h3>',
    trial("Free Trial", "To provide the one-time free trial of scanning, the app stores on your device a counter of how long scanning has run. It is not sent anywhere.") + '<div class="item"><h3>Installed Apps List</h3>')
rep("Subscription verification based on anonymous device identifiers and transactions.",
    "Subscription verification based on anonymous device identifiers and transactions. RevenueCat may also process technical connection data such as an IP address.")

# ---- PL
rep("<b>5 października 2026 r.</b>", "<b>8 października 2026 r.</b>")
rep("nie są udostępniane osobom trzecim ani wykorzystywane do reklam.",
    "nie są udostępniane osobom trzecim ani wykorzystywane do reklam. Usługa nigdy niczego nie klika, nie wpisuje ani nie zmienia na ekranie i nie służy do nagrywania rozmów. Zdarzenia z wszystkich pozostałych aplikacji są natychmiast ignorowane: nic z nich nie jest odczytywane ani zapisywane. Przed włączeniem usługi aplikacja wyświetla objaśnienie i prosi o Twoją zgodę; możesz ją wyłączyć w dowolnej chwili.")
rep("Dostęp do powiadomień służy wyłącznie do wykrywania nowych propozycji zleceń, gdy aplikacja działa w tle.",
    "Dostęp do powiadomień jest opcjonalny i służy wyłącznie do wykrywania nowych propozycji zleceń z obsługiwanych aplikacji, gdy aplikacja działa w tle. Pozostałe powiadomienia nie są odczytywane ani zapisywane.")
rep("obliczone stawki i ocenę każdego ocenionego zlecenia",
    "obliczone stawki, szacowany koszt paliwa, zysk netto i ocenę każdego ocenionego zlecenia")
rep('<div class="item"><h3>Lista zainstalowanych aplikacji</h3>',
    trial("Okres próbny", "Na potrzeby jednorazowego darmowego okresu próbnego skanowania aplikacja zapisuje na Twoim urządzeniu licznik czasu działania skanowania. Nie jest on nigdzie wysyłany.") + '<div class="item"><h3>Lista zainstalowanych aplikacji</h3>')
rep("Weryfikacja subskrypcji na podstawie anonimowych identyfikatorów urządzenia i transakcji.",
    "Weryfikacja subskrypcji na podstawie anonimowych identyfikatorów urządzenia i transakcji. RevenueCat może też przetwarzać techniczne dane połączenia, takie jak adres IP.")

# ---- RU
rep("<b>5 октября 2026 г.</b>", "<b>8 октября 2026 г.</b>")
rep("не передаются третьим лицам и не используются для рекламы.",
    "не передаются третьим лицам и не используются для рекламы. Служба никогда ничего не нажимает, не вводит и не меняет на экране и не используется для записи звонков. События всех остальных приложений сразу игнорируются: ничего из них не читается и не сохраняется. Перед включением службы приложение показывает пояснение и запрашивает ваше согласие; вы можете отключить её в любой момент.")
rep("Доступ к уведомлениям используется только для обнаружения новых предложений заказов, пока приложение работает в фоновом режиме.",
    "Доступ к уведомлениям необязателен и используется только для обнаружения новых предложений заказов от поддерживаемых приложений, пока приложение работает в фоновом режиме. Остальные уведомления не читаются и не сохраняются.")
rep("рассчитанные тарифы и вердикт по каждому оценённому заказу",
    "рассчитанные тарифы, ориентировочные расходы на топливо, чистую прибыль и вердикт по каждому оценённому заказу")
rep('<div class="item"><h3>Список установленных приложений</h3>',
    trial("Пробный период", "Для разового бесплатного пробного периода сканирования приложение хранит на вашем устройстве счётчик времени работы сканирования. Он никуда не отправляется.") + '<div class="item"><h3>Список установленных приложений</h3>')
rep("Проверка подписки на основе анонимных идентификаторов устройства и транзакций.",
    "Проверка подписки на основе анонимных идентификаторов устройства и транзакций. RevenueCat также может обрабатывать технические данные соединения, например IP-адрес.")

# ---- UK
rep("<b>5 жовтня 2026 р.</b>", "<b>8 жовтня 2026 р.</b>")
rep("не використовуються для реклами.",
    "не використовуються для реклами. Служба ніколи нічого не натискає, не вводить і не змінює на екрані та не використовується для запису дзвінків. Події всіх інших застосунків одразу ігноруються: нічого з них не зчитується й не зберігається. Перед увімкненням служби застосунок показує пояснення й запитує вашу згоду; ви можете вимкнути її будь-коли.")
rep("Доступ до сповіщень використовується лише для виявлення нових пропозицій замовлень, поки застосунок працює у фоновому режимі.",
    "Доступ до сповіщень необов’язковий і використовується лише для виявлення нових пропозицій замовлень від підтримуваних застосунків, поки застосунок працює у фоновому режимі. Інші сповіщення не зчитуються й не зберігаються.")
rep("розраховані тарифи та вердикт щодо кожного оціненого замовлення",
    "розраховані тарифи, орієнтовні витрати на пальне, чистий прибуток і вердикт щодо кожного оціненого замовлення")
rep('<div class="item"><h3>Список встановлених застосунків</h3>',
    trial("Пробний період", "Для разового безкоштовного пробного періоду сканування застосунок зберігає на вашому пристрої лічильник часу роботи сканування. Він нікуди не надсилається.") + '<div class="item"><h3>Список встановлених застосунків</h3>')
rep("Перевірка підписки на основі анонімних ідентифікаторів пристрою та транзакцій.",
    "Перевірка підписки на основі анонімних ідентифікаторів пристрою та транзакцій. RevenueCat також може обробляти технічні дані з’єднання, наприклад IP-адресу.")

io.open(P, "w", encoding="utf-8").write(s)
print("updated", P)
PYEOF
else
  echo "Privacy policy NOT changed (add --with-privacy together with the app release)."
fi
echo "Done. Then: git add -A && git commit -m 'Add Instagram contact button' && git push"
