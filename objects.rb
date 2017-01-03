class Card
  def initialize face, value, hide=false
    @value = value
    if face == "10"
      @facet = face
      @faceb = face
    else
      @facet = face+" "
      @faceb = " "+face
    end
    if hide
      @facet = "X "
      @faceb = " X"
      if face == "10"
        @truet = face
        @trueb = face
      else
        @truet = face+" "
        @trueb = " "+face
      end
    end
    show
  end

  def show
    @top = "┌─────┐"
    @md1 = "|   #{@facet}|"
    @md2 = "|     |"
    @md3 = "|#{@faceb}   |"
    @bot = "└─────┘"
  end

  def reveal
    @facet = @truet
    @faceb = @trueb
    show
  end

end

class Deck
  def initialize decks=2
    @faces = {"A"=>11, "2"=>2, "3"=>3, "4"=>4, "5"=>5, "6"=>6, "7"=>7, "8"=>8, "9"=>9, "10"=>10, "J"=>10, "Q"=>10, "K"=>10}
    @cards = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"] * decks * 4
    @decks = decks
  end

  def draw hide=false
    int = rand(0 .. @cards.length-1)
    value = @cards[int]
    @cards.delete_at(int)
    if @cards.length <= (52 * (@decks-1))
      @cards += ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"] * (@decks-1)
    end
    Card.new(value, @faces[value], hide)
  end

end

class Hand
  def initialize
    @hand = []
    @total = 0
    @aces = 0
  end

  def add *card
    @hand += [*card]
    [*card].each do |card|
      @total += card.instance_variable_get(:@value)
      if card.instance_variable_get(:@value) == 11
        @aces += 1
      end
    end
    calculate
    show
  end

  def show
    @top = ""
      @hand.each do |card|
        @top += card.instance_variable_get(:@top) + " "
      end
    @md1 = ""
      @hand.each do |card|
        @md1 += card.instance_variable_get(:@md1) + " "
      end
    @md2 = ""
      @hand.each do |card|
        @md2 += card.instance_variable_get(:@md2) + " "
      end
    @md3 = ""
      @hand.each do |card|
        @md3 += card.instance_variable_get(:@md3) + " "
      end
    @bot = ""
      @hand.each do |card|
        @bot += card.instance_variable_get(:@bot) + " "
      end
  end

  def calculate
    if @total > 21 && @aces > 0
      @total -= 10
      @aces -= 1
      calculate
    end
  end

  def reveal
    @hand[0].reveal
    show
  end

  def win
    calculate
    if @total == 21
      "win"
    elsif @total > 21
      "bust"
    else
      "under"
    end
  end
end

class Player
  def initialize type
    @type = type
    @money = 100
  end

  def hit deck, hide=false
    @hand.add(deck.draw(hide))
  end

  def reset
    @hand = Hand.new
  end

  def reveal
    @hand.reveal
  end

  def cash dif
    @money += dif
  end
end

class Table
  def initialize size=2
    @dealer = Player.new("dealer")
    @user = Player.new("user")
    @deck = Deck.new(size)
  end

  def start
    @user.reset
    @dealer.reset
    @user.hit(@deck)
    @user.hit(@deck)
    @dealer.hit(@deck, true)
    @dealer.hit(@deck)
  end

  def start2
    @user.reset
    @dealer.reset
    @user.instance_variable_get(:@hand).add(Card.new("10", 10), Card.new("A", 11))
    @dealer.hit(@deck, true)
    @dealer.hit(@deck)
  end

  def hit who
    who.hit(@deck)
  end

  def win who
    who.instance_variable_get(:@hand).win
  end


  def show
    types= [:@top, :@md1, :@md2, :@md3, :@bot]
    userstr = @user.instance_variable_get(:@hand).instance_variable_get(:@top) + "    "
    dealerstr = @dealer.instance_variable_get(:@hand).instance_variable_get(:@top)
    print "\n    Your Cards".ljust(userstr.length)
    print "     Dealer's Cards".ljust(dealerstr.length)
    print("\n")
    types.each do |type|
      print "    "
      print @user.instance_variable_get(:@hand).instance_variable_get(type)
      print "    "
      print @dealer.instance_variable_get(:@hand).instance_variable_get(type)
      print "    "
      if type == :@top
        print "Your money: $#{@user.instance_variable_get(:@money)}"
      end
      print "\n"
    end
  end

end
