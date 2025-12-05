import Foundation
import SwiftUI
import PhosphorSwift

// Модель для команды
struct Command: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

// Модель для группы команд
struct CommandGroup: Identifiable {
    let id = UUID()
    let title: String
    let commands: [Command]
}

// Модель для категории
struct Category: Identifiable {
    let id = UUID()
    let icon: Image // Прямая передача Phosphor иконки
    let title: String
    let groups: [CommandGroup]
}

// Данные для всех категорий
let categories: [Category] = [
    // ALIACE
    Category(
        icon: Ph.pawPrint.regular,
        title: "Aliace",
        groups: [
            CommandGroup(
                title: "БАЗА",
                commands: [
                    Command(title: "мяу", description: "перезагрузить настройки терминала"),
                    Command(title: "гау", description: "перезапустить терминал"),
                    Command(title: "гдея", description: "гдея"),
                    Command(title: "файлы", description: "файлы"),
                    Command(title: "вверх", description: "вверх на уровень")
                ]
            ),
            CommandGroup(
                title: "ГИТХАБ",
                commands: [
                    Command(title: "адд", description: "добавить все"),
                    Command(title: "коммит", description: "закоммитить"),
                    Command(title: "пуш", description: "запушить"),
                    Command(title: "статус", description: "узнать статус гита"),
                    Command(title: "пул", description: "подтянуть изменения")
                ]
            ),
            CommandGroup(
                title: "ПОЛЕЗНОЕ",
                commands: [
                    Command(title: "ало", description: "вызов Клауда"),
                    Command(title: "подметика", description: "почистить кеш"),
                    Command(title: "уберися", description: "почистить проект от мусора"),
                    Command(title: "пинг", description: "пингануть google.com"),
                    Command(title: "охота", description: "найти текст в файлах"),
                    Command(title: "эхо", description: "повторить"),
                    Command(title: "сон", description: "подождать")
                ]
            )
        ]
    ),
    
    // GIT
    Category(
        icon: Ph.githubLogo.regular,
        title: "GIT",
        groups: [
            CommandGroup(
                title: "БАЗОВОЕ",
                commands: [
                    Command(title: "git status", description: "Показать состояние рабочей копии репозитория"),
                    Command(title: "git add .", description: "Добавить все изменения в индекс"),
                    Command(title: "git commit -m", description: "Создать коммит с сообщением"),
                    Command(title: "git push", description: "Отправить изменения в удаленный репозиторий"),
                    Command(title: "git pull", description: "Получить изменения из удаленного репозитория")
                ]
            ),
            CommandGroup(
                title: "ВЕТКИ",
                commands: [
                    Command(title: "git branch", description: "Показать список веток"),
                    Command(title: "git checkout -b", description: "Создать и переключиться на новую ветку"),
                    Command(title: "git checkout", description: "Переключиться на другую ветку"),
                    Command(title: "git merge", description: "Объединить ветку с текущей"),
                    Command(title: "git branch -d", description: "Удалить локальную ветку")
                ]
            ),
            CommandGroup(
                title: "ИСТОРИЯ",
                commands: [
                    Command(title: "git log", description: "Показать историю коммитов"),
                    Command(title: "git log --oneline", description: "Показать краткую историю коммитов"),
                    Command(title: "git diff", description: "Показать изменения в файлах"),
                    Command(title: "git show", description: "Показать информацию о коммите"),
                    Command(title: "git reset --hard", description: "Сбросить изменения до указанного коммита")
                ]
            )
        ]
    ),
    
    // NPM
    Category(
        icon: Ph.package.regular,
        title: "NPM",
        groups: [
            CommandGroup(
                title: "УСТАНОВКА",
                commands: [
                    Command(title: "npm install", description: "Установить все зависимости из package.json"),
                    Command(title: "npm install <package>", description: "Установить пакет"),
                    Command(title: "npm install -g <package>", description: "Установить пакет глобально"),
                    Command(title: "npm install --save-dev", description: "Установить пакет как dev-зависимость"),
                    Command(title: "npm uninstall <package>", description: "Удалить пакет")
                ]
            ),
            CommandGroup(
                title: "ЗАПУСК",
                commands: [
                    Command(title: "npm start", description: "Запустить приложение"),
                    Command(title: "npm run dev", description: "Запустить в режиме разработки"),
                    Command(title: "npm run build", description: "Собрать проект для продакшена"),
                    Command(title: "npm test", description: "Запустить тесты"),
                    Command(title: "npm run lint", description: "Проверить код линтером")
                ]
            ),
            CommandGroup(
                title: "УПРАВЛЕНИЕ",
                commands: [
                    Command(title: "npm init", description: "Создать новый package.json"),
                    Command(title: "npm update", description: "Обновить все пакеты"),
                    Command(title: "npm outdated", description: "Показать устаревшие пакеты"),
                    Command(title: "npm list", description: "Показать список установленных пакетов"),
                    Command(title: "npm cache clean --force", description: "Очистить кэш npm")
                ]
            )
        ]
    ),
    
    // FILES
    Category(
        icon: Ph.folder.regular,
        title: "Files",
        groups: [
            CommandGroup(
                title: "НАВИГАЦИЯ",
                commands: [
                    Command(title: "ls -la", description: "Показать все файлы и папки"),
                    Command(title: "cd <path>", description: "Перейти в указанную директорию"),
                    Command(title: "pwd", description: "Показать текущую директорию"),
                    Command(title: "cd ..", description: "Перейти на уровень выше"),
                    Command(title: "cd ~", description: "Перейти в домашнюю директорию")
                ]
            ),
            CommandGroup(
                title: "ОПЕРАЦИИ",
                commands: [
                    Command(title: "mkdir <n>", description: "Создать новую папку"),
                    Command(title: "touch <file>", description: "Создать новый файл"),
                    Command(title: "cp <source> <dest>", description: "Скопировать файл или папку"),
                    Command(title: "mv <source> <dest>", description: "Переместить или переименовать"),
                    Command(title: "rm -rf <path>", description: "Удалить файл или папку")
                ]
            ),
            CommandGroup(
                title: "ПРОСМОТР",
                commands: [
                    Command(title: "cat <file>", description: "Показать содержимое файла"),
                    Command(title: "head <file>", description: "Показать начало файла"),
                    Command(title: "tail <file>", description: "Показать конец файла"),
                    Command(title: "less <file>", description: "Постраничный просмотр файла"),
                    Command(title: "find . -name", description: "Найти файл по имени")
                ]
            )
        ]
    ),
    
    // NETWORK
    Category(
        icon: Ph.globe.regular,
        title: "Network",
        groups: [
            CommandGroup(
                title: "ДИАГНОСТИКА",
                commands: [
                    Command(title: "ping <host>", description: "Проверить доступность хоста"),
                    Command(title: "curl <url>", description: "Выполнить HTTP запрос"),
                    Command(title: "netstat -an", description: "Показать активные соединения"),
                    Command(title: "traceroute <host>", description: "Отследить маршрут до хоста"),
                    Command(title: "nslookup <domain>", description: "Узнать IP адрес домена")
                ]
            ),
            CommandGroup(
                title: "ПЕРЕДАЧА",
                commands: [
                    Command(title: "scp <file> <user@host>", description: "Скопировать файл на удаленный сервер"),
                    Command(title: "wget <url>", description: "Скачать файл по URL"),
                    Command(title: "rsync -av", description: "Синхронизировать файлы"),
                    Command(title: "ssh <user@host>", description: "Подключиться по SSH"),
                    Command(title: "sftp <user@host>", description: "Подключиться по SFTP")
                ]
            ),
            CommandGroup(
                title: "МОНИТОРИНГ",
                commands: [
                    Command(title: "lsof -i", description: "Показать открытые сетевые соединения"),
                    Command(title: "ifconfig", description: "Показать сетевые интерфейсы"),
                    Command(title: "ss -tuln", description: "Показать прослушиваемые порты"),
                    Command(title: "tcpdump", description: "Захват сетевых пакетов"),
                    Command(title: "iftop", description: "Мониторинг сетевого трафика")
                ]
            )
        ]
    ),
    
    // SYSTEM
    Category(
        icon: Ph.gear.regular,
        title: "System",
        groups: [
            CommandGroup(
                title: "ПРОЦЕССЫ",
                commands: [
                    Command(title: "top", description: "Показать активные процессы"),
                    Command(title: "ps aux", description: "Список всех процессов"),
                    Command(title: "kill <pid>", description: "Завершить процесс по ID"),
                    Command(title: "killall <n>", description: "Завершить процессы по имени"),
                    Command(title: "htop", description: "Интерактивный монитор процессов")
                ]
            ),
            CommandGroup(
                title: "СИСТЕМА",
                commands: [
                    Command(title: "df -h", description: "Показать использование дискового пространства"),
                    Command(title: "du -sh", description: "Размер директории"),
                    Command(title: "free -h", description: "Показать использование памяти"),
                    Command(title: "uptime", description: "Время работы системы"),
                    Command(title: "uname -a", description: "Информация о системе")
                ]
            ),
            CommandGroup(
                title: "ПРАВА",
                commands: [
                    Command(title: "chmod +x <file>", description: "Сделать файл исполняемым"),
                    Command(title: "chmod 755 <file>", description: "Установить права доступа"),
                    Command(title: "chown <user> <file>", description: "Изменить владельца файла"),
                    Command(title: "sudo <command>", description: "Выполнить команду с правами root"),
                    Command(title: "su - <user>", description: "Переключиться на другого пользователя")
                ]
            )
        ]
    ),
    
]
