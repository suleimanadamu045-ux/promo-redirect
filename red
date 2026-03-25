<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Безопасный переход...</title>
    <style>
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; 
            display: flex; justify-content: center; align-items: center; 
            height: 100vh; background-color: #f4f4f9; text-align: center; 
            margin: 0; padding: 20px; box-sizing: border-box; 
        }
        .container { 
            background: white; padding: 30px; border-radius: 12px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.1); max-width: 400px; width: 100%;
        }
        h2 { color: #333; margin-top: 0; }
        p { color: #666; font-size: 16px; line-height: 1.5; }
        .btn { 
            display: inline-block; margin-top: 20px; padding: 14px 24px; 
            background-color: #007bff; color: white; text-decoration: none; 
            border-radius: 8px; font-weight: bold; width: 80%; box-sizing: border-box;
        }
        .ios-instruction { 
            display: none; margin-top: 15px; background: #eef7ff; 
            padding: 15px; border-radius: 8px; border-left: 4px solid #007bff; 
            text-align: left; font-size: 15px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 id="status">Загрузка платформы...</h2>
    <p id="description">Пожалуйста, подождите пару секунд.</p>
    
    <div id="ios-guide" class="ios-instruction">
        <p style="margin-top:0;"><b>Встроенный браузер ограничивает функции регистрации.</b> Чтобы продолжить:</p>
        <ol style="margin-bottom:0; padding-left: 20px;">
            <li>Нажмите на <b>три точки</b> ⋯ (или иконку компаса) в углу экрана.</li>
            <li>Выберите <b>«Открыть в браузере»</b> (Open in system browser).</li>
        </ol>
    </div>

    <a href="#" id="fallback-link" class="btn" style="display:none;">Перейти к регистрации</a>
</div>

<script>
    // 1. Ваша базовая целевая ссылка
    const baseUrlString = "https://betcity.by/mobile/ru/reg#utm_content=bonus_ig_lead&utm_source=ig&utm_medium=cpc&utm_campaign=bonus_ig_lead";
    
    // 2. Функция для "проброса" динамических UTM-меток
    function buildFinalUrl() {
        try {
            // Создаем объект URL из вашей ссылки
            const finalUrl = new URL(baseUrlString);
            
            // Получаем все параметры (query string), с которыми пользователь пришел на прокладку
            const currentParams = new URLSearchParams(window.location.search);
            
            // Перебираем и добавляем их к финальной ссылке
            currentParams.forEach((value, key) => {
                finalUrl.searchParams.set(key, value);
            });
            
            return finalUrl.toString();
        } catch (e) {
            // Фолбек на случай старых устройств, не поддерживающих URL API
            return baseUrlString;
        }
    }

    const targetUrl = buildFinalUrl();
    
    // Подготовка ссылки для Android (убираем https://)
    const urlWithoutProtocol = targetUrl.replace(/^https?:\/\//, "");

    const ua = navigator.userAgent || navigator.vendor || window.opera;
    const isInstagram = (ua.indexOf('Instagram') > -1);
    const isFacebook = (ua.indexOf('FBAV') > -1 || ua.indexOf('FBAN') > -1);
    const isAndroid = /android/i.test(ua);
    const isIOS = /iPad|iPhone|iPod/.test(ua) && !window.MSStream;

    window.onload = function() {
        if (isInstagram || isFacebook) {
            if (isAndroid) {
                document.getElementById('status').innerText = "Запуск Chrome...";
                // Intent для Android
                window.location.href = "intent://" + urlWithoutProtocol + "#Intent;scheme=https;package=com.android.chrome;end";
                
                // Страховочная кнопка
                setTimeout(() => {
                    document.getElementById('fallback-link').href = targetUrl;
                    document.getElementById('fallback-link').style.display = "inline-block";
                }, 2000);
            } 
            else if (isIOS) {
                document.getElementById('status').innerText = "Требуется Safari";
                document.getElementById('description').style.display = "none";
                document.getElementById('ios-guide').style.display = "block";
                
                document.getElementById('fallback-link').href = targetUrl;
                document.getElementById('fallback-link').style.display = "inline-block";
            }
        } else {
            // Если открыли с ПК или в нормальном мобильном браузере - редирект мгновенный
            window.location.replace(targetUrl);
        }
    };
</script>

</body>
</html>
