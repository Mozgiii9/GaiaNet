import requests
import time
import random

url = input("Введите URL для отправки запроса: ")
headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json'
}

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

def send_request():
    question = random.choice(questions)
    data = {
        "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": question}
        ]
    }
    response = requests.post(url, headers=headers, json=data)
    if response.status_code == 200:
        print(f"Response: {response.json()}")
    else:
        print(f"Failed to get response, status code: {response.status_code}")

def main():
    sleep_hours = 8
    sleep_seconds = sleep_hours * 3600

    while True:
        num_requests = random.randint(6, 12)

        for _ in range(num_requests):
            send_request()
            delay = random.randint(60, 300)
            print(f"Waiting for {delay // 60} minutes...")
            time.sleep(delay)

        long_break = random.randint(1800, 3600)
        print(f"Taking a break for {long_break // 60} minutes...")
        time.sleep(long_break)

        print(f"Sleeping for {sleep_hours} hours...")
        time.sleep(sleep_seconds)

if __name__ == "__main__":
    main()
