#!/bin/bash

# Название файла для Python скрипта
PYTHON_SCRIPT_NAME="request_script.py"

# Проверка, запущен ли скрипт с правами суперпользователя
if [ "$EUID" -ne 0 ]; then
    echo "Пожалуйста, запустите скрипт с правами суперпользователя (sudo)."
    exit 1
fi

# Проверка, установлен ли Python, и установка, если он не установлен
if ! command -v python3 &> /dev/null
then
    echo "Python3 не найден, устанавливаем..."
    sudo apt update
    sudo apt install python3 python3-pip -y
else
    echo "Python3 уже установлен"
fi

# Установка virtualenv, если не установлен
if ! pip3 show virtualenv &> /dev/null; then
    echo "Устанавливаем virtualenv..."
    pip3 install virtualenv
else
    echo "virtualenv уже установлен"
fi

# Создание виртуального окружения
VENV_DIR="venv"
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv $VENV_DIR
fi

# Активация виртуального окружения
source $VENV_DIR/bin/activate

# Установка библиотеки requests, если она не установлена
pip3 show requests &> /dev/null
if [ $? -ne 0 ]; then
    echo "Библиотека requests не найдена, устанавливаем..."
    pip3 install requests
else
    echo "Библиотека requests уже установлена"
fi

# Создание Python скрипта
echo "Создаем Python скрипт..."
cat << EOF > $PYTHON_SCRIPT_NAME
import requests
import time
import random
import logging

# Настройка логирования для вывода в консоль
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(message)s")

# URL и заголовки для запроса
url = input("Введите URL для отправки запроса: ")
headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json'
}

# 100 вопросов для рандомизации
questions = [
    "Where is Paris?", "What is the capital of Germany?", "How far is the moon from the Earth?",
    "Who wrote 'To Kill a Mockingbird'?", "What is the speed of light?", "How many continents are there?",
    "What is the tallest mountain in the world?", "Who painted the Mona Lisa?", "What is the largest ocean on Earth?",
    "How many planets are in our solar system?", "What is the capital of Japan?", "Who discovered penicillin?",
    "What is the longest river in the world?", "Who is the current president of the United States?",
    "What is the largest desert in the world?", "How many states are there in the USA?", "What is the smallest country in the world?",
    "Who was the first person to walk on the moon?", "What is the chemical symbol for gold?", "What is the highest waterfall in the world?",
    "What is the capital of Australia?", "Who wrote '1984'?", "What is the largest mammal?", "Who developed the theory of relativity?",
    "What is the fastest land animal?", "How many bones are in the human body?", "What is the largest island in the world?",
    "What is the most spoken language in the world?", "What is the capital of Canada?", "Who invented the telephone?",
    "What is the currency of Japan?", "What is the capital of Russia?", "What is the longest wall in the world?",
    "What is the most populous country in the world?", "What is the capital of Italy?", "What is the largest planet in the solar system?",
    "Who wrote 'Pride and Prejudice'?", "What is the largest lake in the world?", "What is the capital of India?",
    "Who painted the Sistine Chapel ceiling?", "What is the smallest bone in the human body?", "What is the capital of Brazil?",
    "What is the highest mountain in North America?", "What is the capital of China?", "Who wrote 'The Catcher in the Rye'?",
    "What is the deepest ocean trench?", "What is the capital of Mexico?", "Who discovered America?",
    "What is the chemical symbol for water?", "What is the largest coral reef system?", "Who is known as the father of computers?",
    "What is the capital of Argentina?", "What is the largest landlocked country?", "Who invented the light bulb?",
    "What is the longest river in Africa?", "What is the capital of South Africa?", "Who wrote 'Moby-Dick'?",
    "What is the speed of sound?", "What is the largest city in the world?", "What is the capital of Egypt?",
    "Who painted 'Starry Night'?", "What is the coldest place on Earth?", "What is the capital of Saudi Arabia?",
    "Who is the author of 'Harry Potter'?", "What is the highest building in the world?", "What is the capital of Spain?",
    "Who discovered the electron?", "What is the hottest planet in the solar system?", "What is the capital of Thailand?",
    "Who wrote 'The Great Gatsby'?", "What is the oldest known civilization?", "What is the capital of Turkey?",
    "Who invented the airplane?", "What is the largest rainforest in the world?", "What is the capital of Indonesia?",
    "Who painted 'The Last Supper'?", "What is the capital of Greece?", "Who developed the polio vaccine?",
    "What is the capital of Vietnam?", "What is the most abundant gas in the Earth's atmosphere?", "What is the capital of Iran?",
    "Who wrote 'The Odyssey'?", "What is the capital of Portugal?", "Who invented the printing press?",
    "What is the largest country in the world by area?", "What is the capital of Norway?", "Who wrote 'War and Peace'?",
    "What is the smallest ocean?", "What is the capital of Sweden?", "Who discovered gravity?",
    "What is the most populous city in the world?", "What is the capital of Kenya?", "Who wrote 'Don Quixote'?",
    "What is the largest river by volume?", "What is the capital of Peru?", "Who invented the World Wide Web?",
    "What is the capital of Pakistan?", "What is the most widely used programming language?", "What is the capital of Chile?",
    "Who wrote 'Crime and Punishment'?", "What is the capital of Malaysia?", "Who painted 'The Persistence of Memory'?"
]

# Функция для отправки запроса
def send_request():
    try:
        # Выбираем случайный вопрос
        question = random.choice(questions)
        # Формируем тело запроса
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

# Установка screen, если не установлен
if ! command -v screen &> /dev/null
then
    echo "screen не найден, устанавливаем..."
    sudo apt install screen -y
else
    echo "screen уже установлен"
fi

# Запуск Python скрипта в фоновом режиме через screen
screen -dmS python_script_session bash -c "source $VENV_DIR/bin/activate && python3 $PYTHON_SCRIPT_NAME | tee -a request_script.log"

echo "Скрипт $PYTHON_SCRIPT_NAME запущен в фоновом режиме через screen."
echo "Чтобы подключиться к сессии screen и посмотреть логи, используйте команду: screen -r python_script_session"
