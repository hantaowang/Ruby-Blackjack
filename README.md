      /$$$$$$$  /$$                     /$$                               /$$
     | $$__  $$| $$                    | $$                              | $$
     | $$  \ $$| $$  /$$$$$$   /$$$$$$$| $$   /$$ /$$  /$$$$$$   /$$$$$$$| $$   /$$
     | $$$$$$$ | $$ |____  $$ /$$_____/| $$  /$$/|__/ |____  $$ /$$_____/| $$  /$$/
     | $$__  $$| $$  /$$$$$$$| $$      | $$$$$$/  /$$  /$$$$$$$| $$      | $$$$$$/
     | $$  \ $$| $$ /$$__  $$| $$      | $$_  $$ | $$ /$$__  $$| $$      | $$_  $$
     | $$$$$$$/| $$|  $$$$$$$|  $$$$$$$| $$ \  $$| $$|  $$$$$$$|  $$$$$$$| $$ \  $$
     |_______/ |__/ \_______/ \_______/|__/  \__/| $$ \_______/ \_______/|__/  \__/
     ┌───────────────────────────────────┐  /$$  | $$ ┌─────────────────────────────┐
     └───────────────────────────────────┘ |  $$$$$$/ └─────────────────────────────┘
     Built on Ruby                          \______/
     Version 1.01
     by Will Wang @ hantaowang.me
======
####Background
I taught myself Ruby originally because I wanted to eventually learn Rails and eventually also at the recommendation of my girlfriend, who had a wonderful introduction to Ruby [textbook](https://pine.fm/LearnToProgram/). I wanted my first major ruby program to be a blackjack game, which was also my first major program in Python. 

As it turns out, blackjack is a great program to test out the basics of a language, as it incorporates ideas such as flow control, iteration, arrays, mathematics, etc. This ruby implementation of blackjack is also my first to use object-orientated programming. The classes are defined in the `objects.rb` file. 

####How to play
To run the game, you need to have Ruby downloaded and a command line interpreter such as Terminal or Gitbash installed. If you are running MacOS, then you already have both preinstalled. For Windows users, Ruby can be downloaded [here](https://www.ruby-lang.org/en/). Download the files and run `ruby blackjack.rb` to begin. Instructions on how to play blackjack are provided in game.

####Interesting Note
This implemenation of blackjack is set up like how it would be at the casino: with a 6-deck stack called a "shoe," from which cards are drawn without replacement and refilled when needed. Because of this, it is possible to actually count cards or at least practice card counting without being kicked out of the casino. 
