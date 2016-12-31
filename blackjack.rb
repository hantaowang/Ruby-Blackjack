require_relative "objects"
print "\e[8;35;125t"

size = 6

(0..50).each do puts "" end
print "
     /$$$$$$$  /$$                     /$$                               /$$
    | $$__  $$| $$                    | $$                              | $$
    | $$  \\ $$| $$  /$$$$$$   /$$$$$$$| $$   /$$ /$$  /$$$$$$   /$$$$$$$| $$   /$$
    | $$$$$$$ | $$ |____  $$ /$$_____/| $$  /$$/|__/ |____  $$ /$$_____/| $$  /$$/
    | $$__  $$| $$  /$$$$$$$| $$      | $$$$$$/  /$$  /$$$$$$$| $$      | $$$$$$/
    | $$  \\ $$| $$ /$$__  $$| $$      | $$_  $$ | $$ /$$__  $$| $$      | $$_  $$
    | $$$$$$$/| $$|  $$$$$$$|  $$$$$$$| $$ \\  $$| $$|  $$$$$$$|  $$$$$$$| $$ \\  $$
    |_______/ |__/ \\_______/ \\_______/|__/  \\__/| $$ \\_______/ \\_______/|__/  \\__/
    ┌───────────────────────────────────┐  /$$  | $$ ┌─────────────────────────────┐
    └───────────────────────────────────┘ |  $$$$$$/ └─────────────────────────────┘
    Built on Ruby                          \\______/
    Version 1.01
    by Will Wang @ hantaowang.me

    The version of blackjack is played with a standard #{size} deck stack. Cards are
    drawn from the stack randomly and without replacement until there is only 1 deck
    (52 cards) left in the stack. Then complete decks are added to the stack until
    the stack is full again.

    No splitting pairs, doubling down, or insurance is allowed.\n"



env = Table.new(size)

user = env.instance_variable_get(:@user)
dealer = env.instance_variable_get(:@dealer)

def blanks
  (0..50).each do puts "" end
end

start = ""
while start.downcase != "\n"
  print "\n    For the complete rules, type \"help\". Otherwise press ENTER to begin: "
  start = gets
  if start.downcase == "help\n"
    blanks
    print "
    RULES:

    Each player is dealt 2 face up cards from the stack. The dealer receives 1 face up, 1 face down card.
    The object of the game is the get their cards' total value as close to 21 as possible without going
    over, which is called a bust. Aces are worth either 1 or 11 points. This is up to the player to decide.
    All face cards are worth 10 points. Players only play against the dealer. Blackjack is when the total
    equals 21.

    On the initial deal, if anyone receives an ace and a 10-card, this is called a natural as blackjack
    is acheived right away. If the dealer receives a natural and the player does not, the player loses
    their bet. If the player receives a natural and the dealer does not, the dealer pays out 1.5 times
    the bet. If both players receives a natural, it is a tie and the player recollects their bet.

    The game is player by the player first and then the dealer. Each player has the option to stand or hit.
    Stand means that the player has decided to receive no more cards. A hit means the player receives one
    more card. If that card brings the total over 21, then the player busts and loses their bet. A player
    has the option to hit until he reaches or passes 21.

    The dealer plays last in blackjack in the same fashion as the players. However bets are nonrefundable.
    If the dealer busts, players who lost their bets as the result of a bust do not have their money returned.
    However all players who have not bust wins their bet.

    If both the player and the dealer achieve blackjack (not as the result of a natural), then the winner is
    the one who achieves it with the least amount of cards. If both use the same amount, then it is a tie. If
    neither player has blackjack, then the player with the highest total that is not over 21 wins.

    The fact that cards are drawn from a nonreplacement deck means that card counting is possible, but
    very difficult. Keep in mind that the deck is refilled when only 52 cards remain.

    Good luck!
    "
    while start != "\n"
      print "\n    >>> Press ENTER to begin the game: "
      start = gets
    end
    break
  end
end

game = true
while game
  contiune = true
  money = user.instance_variable_get(:@money)
  bet = 0
  while (bet <= 0 || bet > money)
    print "\n    >>> You have $#{money}\n    >>> How much money do you want to bet?: $"
    bet = gets.chomp.to_f.round(2)
  end
  puts "\n    >>> You bet $#{bet}\n    >>> Dealer will now deal cards."
  user.cash(-bet)
  sleep 1
  env.start
  if env.win(user)=="win"
    env.show
    puts "\n    >>> You got blackjack!!!"
    playerstatus = "natural"
    if env.win(dealer) == "win"
      env.reveal
      env.show
      puts "    >>> But so did the dealer."
      dealerstatus = "natural"
      contiune = false
    else
      contiune = false
    end
  elsif env.win(dealer) == "win"
    env.reveal
    env.show
    dealerstatus = "natural"
    puts "\n    >>> The dealer got blackjack!"
    contiune = false
  end

  while contiune
    env.show
    action = ""
    while action.downcase != "h" && action.downcase != "s"
      print "    >>> Hit or Stand? (H/S): "
      action = gets.chomp
    end
    if action.downcase == "h"
      env.hit(user)
    else
      contiune = false
      playerstatus = "stay"
    end
    if env.win(user)=="win"
      env.show
      puts "\n    >>> Congradulations you got blackjack"
      playerstatus = "blackjack"
      break
    elsif env.win(user)=="bust"
      env.show
      puts "\n    >>> Sorry you bust"
      playerstatus = "bust"
      break
    end
  end

  def autoturn dealer
    hand = dealer.instance_variable_get(:@hand)
    if hand.instance_variable_get(:@total) >= 17
      if hand.instance_variable_get(:@aces) > 0
        true
      else
        false
      end
    else
      true
    end
  end

  if (autoturn dealer) == false
    dealerstatus = "stay"
  end

  while (autoturn dealer) && (playerstatus != "bust") && (playerstatus != "natural") && (dealerstatus != "natural")
    sleep 1
    env.hit(dealer)
    puts "\n    >>> Dealer hits"
    env.show
    if env.win(dealer)=="win"
      sleep 1
      puts "\n    >>> Dealer got blackjack"
      dealer.reveal
      env.show
      dealerstatus = "blackjack"
      break
    elsif env.win(dealer)=="bust"
      sleep 1
      puts "\n    >>> Dealer busted"
      dealer.reveal
      env.show
      dealerstatus = "bust"
      break
    else
      dealerstatus = "stay"
    end
  end



  sleep 1
  if playerstatus == "stay" && dealerstatus == "stay"
    puts "\n    >>> Dealer stays"
    sleep 1
    puts "\n    >>> Showdown"
    dealer.reveal
    sleep 1
    env.show
    puts "\n    Your total: #{user.instance_variable_get(:@hand).instance_variable_get(:@total)}        Dealer's total: #{dealer.instance_variable_get(:@hand).instance_variable_get(:@total)}"
    sleep 1
    if user.instance_variable_get(:@hand).instance_variable_get(:@total) > dealer.instance_variable_get(:@hand).instance_variable_get(:@total)
      puts "\n    >>> You won!"
      payout = 2
    elsif user.instance_variable_get(:@hand).instance_variable_get(:@total) < dealer.instance_variable_get(:@hand).instance_variable_get(:@total)
      puts "\n    >>> You lost!"
      payout = 0
    else
      if user.instance_variable_get(:@hand).instance_variable_get(:@hand).length > dealer.instance_variable_get(:@hand).instance_variable_get(:@hand).length
        puts "\n    >>> You lost!"
        payout = 0
      elsif user.instance_variable_get(:@hand).instance_variable_get(:@hand).length < dealer.instance_variable_get(:@hand).instance_variable_get(:@hand).length
        puts "\n    >>> You won!"
        payout = 2
      else
        puts "\n    >>> Its a tie!"
        payout = 1
      end
    end
  elsif playerstatus == "natural" && dealerstatus != "natural"
    puts "\n    >>> You won!"
    payout = 2.5
  elsif playerstatus != "natural" && dealerstatus == "natural"
    puts "\n    >>> You lost!"
    payout = 0
  elsif playerstatus == "bust"
    puts "\n    >>> You lost!"
    payout = 0
  elsif dealerstatus == "bust"
    puts "\n    >>> You won!"
    payout = 2
  elsif playerstatus == "blackjack" && dealerstatus != "blackjack"
    puts "\n    >>> You won!"
    payout = 2
  elsif playerstatus != "blackjack" && dealerstatus == "blackjack"
    puts "\n    >>> You lost!"
    payout = 0
  elsif playerstatus == "blackjack" && dealerstatus == "blackjack"
    if user.instance_variable_get(:@hand).instance_variable_get(:@hand).length > dealer.instance_variable_get(:@hand).instance_variable_get(:@hand).length
      puts "\n    >>> You lost!"
      payout = 0
    elsif user.instance_variable_get(:@hand).instance_variable_get(:@hand).length < dealer.instance_variable_get(:@hand).instance_variable_get(:@hand).length
      puts "\n    >>> You won!"
      payout = 2
    else
      puts "\n    >>> Its a tie!"
      payout = 1
    end
  else
    puts "\n    >>> Win Error"
    puts playerstatus
    puts dealerstatus
  end

  user.cash(bet*payout)
  sleep 1
  if user.instance_variable_get(:@money) <= 0
    puts "\n    >>> Game over! You have lost all your money!\n\n"
    game = false
  else
    play = ""
    while play != "y" && play != "n"
      print "\n    >>> Would you like to contiune playing (Y/N): "
      play = gets.chomp.downcase
    end
    if play == "y"
      game = true
    else
      game = false
    end
  end

end
sleep 1
if user.instance_variable_get(:@money) > 100
  puts "\n\n    Congradulations, you finished with $#{user.instance_variable_get(:@money)}! You earned $#{user.instance_variable_get(:@money)-100} dollars!"
elsif user.instance_variable_get(:@money) == 0
  puts "\n\n    Whoops, you lost all your money! Better luck next time..."
elsif user.instance_variable_get(:@money) < 100
  puts "\n\n    Whoops, you finished with $#{user.instance_variable_get(:@money)}! You lost $#{100-user.instance_variable_get(:@money)} dollars!"
else
  puts "\n\n    Well, you finished with $#{user.instance_variable_get(:@money)}! Looks like you didn't make or lose money..."
end
sleep 1
puts "\n    Good Bye!\n\n"
