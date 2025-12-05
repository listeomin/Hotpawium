# 🚀 Инструкция: Как создать релизное приложение HotpawsXcode

## Метод 1: Archive (Рекомендуется для распространения)

### Шаги в Xcode:

1. **Открой проект в Xcode**
   - Открой файл `HotpawsXcode.xcodeproj`

2. **Выбери схему и платформу**
   - В верхней панели выбери схему: `HotpawsXcode`
   - Выбери платформу: `Any Mac`

3. **Создай Archive**
   - Меню: `Product` → `Archive`
   - Подожди завершения сборки (может занять несколько минут)

4. **Экспортируй приложение**
   - Откроется окно Organizer
   - Выбери только что созданный архив
   - Нажми `Distribute App`
   - Выбери `Copy App`
   - Укажи папку для сохранения (например, `~/Desktop/HotpawsXcode-Release`)
   - Нажми `Export`

5. **Установи приложение**
   - Перейди в папку с экспортированным приложением
   - Перетащи `HotpawsXcode.app` в папку `/Applications`

---

## Метод 2: Через командную строку (быстрый способ)

### Команды в терминале:

```bash
# Перейди в папку проекта
cd /Users/ufoanima/Dev/experiments/HotpawsXcode

# Собери Release билд
xcodebuild -project HotpawsXcode.xcodeproj \
  -scheme HotpawsXcode \
  -configuration Release \
  -derivedDataPath ./build \
  clean build

# Найди собранное приложение
open build/Build/Products/Release/
```

Приложение будет в папке `build/Build/Products/Release/HotpawsXcode.app`

Можешь просто перетащить его в `/Applications`

---

## Метод 3: Простой Release Build в Xcode

1. В Xcode выбери схему `Edit Scheme...`
2. Выбери `Run` в левой панели
3. Измени `Build Configuration` с `Debug` на `Release`
4. Нажми `Close`
5. Запусти проект: `Cmd + R`
6. Найди собранное приложение в:
   ```
   ~/Library/Developer/Xcode/DerivedData/HotpawsXcode-xxx/Build/Products/Release/
   ```

---

## Проверка иконки

После установки приложения в `/Applications`:
- Иконка должна отображаться в Finder
- Иконка должна отображаться в Dock
- Иконка должна отображаться при запуске приложения

Если иконка не отображается:
```bash
# Очисти кэш иконок
sudo rm -rf /Library/Caches/com.apple.iconservices.store
killall Dock
killall Finder
```

---

## Файлы проекта

✅ **Иконка добавлена:** `/Users/ufoanima/Dev/experiments/HotpawsXcode/HotpawsXcode/AppIcon.icns`
✅ **Info.plist обновлен:** добавлен ключ `CFBundleIconFile`

---

## Дополнительные настройки (опционально)

### Если хочешь подписать приложение:

В Xcode:
1. Открой проект
2. Выбери Target `HotpawsXcode`
3. Перейди на вкладку `Signing & Capabilities`
4. Выбери свою команду разработчика
5. Xcode автоматически настроит сертификаты

### Если хочешь нотаризовать приложение для распространения:

```bash
# После экспорта архива
xcrun notarytool submit HotpawsXcode.app.zip \
  --apple-id your-email@example.com \
  --password your-app-specific-password \
  --team-id YOUR_TEAM_ID \
  --wait
```

---

## Быстрый старт (Самый простой способ)

```bash
cd /Users/ufoanima/Dev/experiments/HotpawsXcode

# Собери Release билд
xcodebuild -project HotpawsXcode.xcodeproj \
  -scheme HotpawsXcode \
  -configuration Release \
  clean build

# Скопируй в Applications
cp -R ~/Library/Developer/Xcode/DerivedData/HotpawsXcode-*/Build/Products/Release/HotpawsXcode.app \
  /Applications/

echo "✅ Готово! Приложение установлено в /Applications"
```

Открой Finder → Applications → HotpawsXcode.app 🎉
