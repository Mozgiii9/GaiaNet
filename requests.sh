#!/bin/bash

# Название файла для Python скрипта
PYTHON_SCRIPT_NAME="request_script.py"
VENV_DIR="venv"

# Проверка, запущен ли скрипт с правами суперпользователя
if [ "$EUID" -ne 0 ]; then
    echo "Пожалуйста, запустите скрипт с правами суперпользователя (sudo)."
    exit 1
fi

# Проверка, установлен ли Python, и установка, если он не установлен
if ! command -v python3 &> /dev/null
then
    echo "Python3 не найден, устанавливаем..."
    apt update
    apt install python3 -y
else
    echo "Python3 уже установлен"
fi

# Установка python3-venv, если не установлен
if ! dpkg -s python3-venv &> /dev/null; then
    echo "Устанавливаем python3-venv..."
    apt install python3-venv -y
else
    echo "python3-venv уже установлен"
fi

# Проверка, установлен ли pip, и установка, если он не установлен
if ! command -v pip3 &> /dev/null
then
    echo "pip3 не найден, устанавливаем..."
    apt update
    apt install python3-pip -y
else
    echo "pip3 уже установлен"
fi

# Установка virtualenv, если не установлен
if ! pip3 show virtualenv &> /dev/null; then
    echo "Устанавливаем virtualenv..."
    pip3 install virtualenv
else
    echo "virtualenv уже установлен"
fi

# Создание виртуального окружения
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv $VENV_DIR
fi

# Активация виртуального окружения
source $VENV_DIR/bin/activate

# Установка библиотек requests и faker, если они не установлены
if ! pip3 show requests &> /dev/null; then
    echo "Библиотека requests не найдена, устанавливаем..."
    pip3 install requests
else
    echo "Библиотека requests уже установлена"
fi

if ! pip3 show faker &> /dev/null; then
    echo "Библиотека Faker не найдена, устанавливаем..."
    pip3 install faker
else
    echo "Библиотека Faker уже установлена"
fi

# Создание Python скрипта
echo "Создаем Python скрипт..."
cat << EOF > $PYTHON_SCRIPT_NAME
import requests
import time
import random
import logging
from faker import Faker

# Настройка логирования для вывода в консоль
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(message)s")

# URL и заголовки для запроса
url = input("Введите URL для отправки запроса: ")
headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json'
}

# Инициализация Faker для генерации случайных вопросов
faker = Faker()

# Функция для отправки запроса
def send_request():
    try:
        # Генерация случайного вопроса с использованием Faker
        question = faker.sentence(nb_words=10)
        # Формирование тела запроса
        data = {
            "messages": [
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": question}
            ]
        }
        logging.info(f"Отправка запроса с вопросом: {question}")
        response = requests.post(url, headers=headers, json=data)
        if response.status_code == 200:
            logging.info(f"Ответ: {response.json()}")
        else:
            logging.error(f"Ошибка получения ответа, статус-код: {response.status_code}")
    except Exception as e:
        logging.error(f"Произошла ошибка при отправке запроса: {str(e)}")

# Основной цикл
def main():
    sleep_hours = 8  # Часы для сна
    sleep_seconds = sleep_hours * 3600  # Перевод в секунды

    while True:
        # Определяем случайное количество запросов перед длинным перерывом
        num_requests = random.randint(6, 12)  # От 6 до 12 запросов (в среднем около часа)

        for _ in range(num_requests):
            send_request()
            # Случайная задержка между запросами от 1 до 5 минут
            delay = random.randint(60, 300)
            logging.info(f"Ожидание {delay // 60} минут...")
            time.sleep(delay)

        # Длинный перерыв от 30 минут до 1 часа
        long_break = random.randint(1800, 3600)
        logging.info(f"Перерыв на {long_break // 60} минут...")
        time.sleep(long_break)

        # Перерыв на сон каждые 24 часа
        logging.info(f"Сон на {sleep_hours} часов...")
        time.sleep(sleep_seconds)

if __name__ == "__main__":
    main()
EOF

# Проверка, установлен ли screen
if ! command -v screen &> /dev/null
then
    echo "screen не найден, устанавливаем..."
    apt install screen -y
else
    echo "screen уже установлен"
fi

# Запуск Python скрипта в фоновом режиме через screen
screen -dmS python_script_session bash -c "source $VENV_DIR/bin/activate && python3 $PYTHON_SCRIPT_NAME | tee -a request_script.log"

echo "Скрипт $PYTHON_SCRIPT_NAME запущен в фоновом режиме через screen."
echo "Чтобы подключиться к сессии screen и посмотреть логи, используйте команду: screen -r python_script_session"
