package main

import (
	clientBot "example.com/DiscrodC2/Bot"
	"os"
	"github.com/joho/godotenv"
)

func main() {

	err := godotenv.Load()
	if err != nil {
		os.Exit(3)
	}

	clientBot.BotToken = os.Getenv("BOT_TOKEN")
	//clientBot.UserID1 = os.Getenv("USER1_ID")
	//clientBot.UserID2 = os.Getenv("USER2_ID")
	clientBot.Run()
}