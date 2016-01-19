#JEU DE COMBAT DANS LA CONSOLE - TP OPEN CLASSROOMS

class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    if @en_vie
    	return "#{@nom} (#{@points_de_vie.to_s} /100 pts de vie)"
    else
    	return @nom + " vaincu"
    end
  end

  def attaque(personne)
  # Le joueur attaque la personne passée en paramètre
    puts "#{@nom} attaque #{personne.nom}"

    if personne.en_vie
    	personne.subit_attaque(degats)
    else
    	puts "#{personne.nom} a déjà été vaincu"
    end
  end


  def subit_attaque(degats_recus)
  # Le joueur attaqué perd des points de vie en fonction des dégâts reçus
    @points_de_vie -= degats_recus
    puts "#{nom} vient de subir #{degats_recus} points de dégâts"
  # On vérifie si la personne attaquée est toujours en vie
    puts "#{@nom} a été vaincu" if @points_de_vie <= 0
  end

end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    # Par défaut le joueur n'a pas de dégâts bonus
    @degats_bonus = 0

    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def degats
  # Les dégâts sont variables à chaque attaque
    degats = rand(1..20) + degats_bonus
    puts "#{@nom} inflige #{degats} points de dégâts"
    return degats
  end

  def soin
    @points_de_vie += rand(10..25)
    puts "#{@nom} s'est soigné et a gagné #{points_de_vie} points de vie"
  end

  def ameliorer_degats
  # Si le joueur améliore son attaque, il recharge ses dégâts-bonus
    @degats_bonus += rand(25)
    puts "#{@nom} bénéficie de #{@degats_bonus} points de dégâts-bonus supplémentaires"
end
end

class Ennemi < Personne

  def degats
    degats = rand(1..30)
    puts "#{@nom} a provoqué #{degats} points de dégâts"
    return degats
  end

end

class Jeu

  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Se soigner"
    puts "1 - Améliorer son attaque"

    # On commence à 2 car 0 et 1 sont réservés pour les actions
    # de soin et d'amélioration d'attaque
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)
  # Le jeu est fini si le joueur est vaincu ou s'il n'y a plus d'ennemis à vaincre
    return true if joueur.points_de_vie <=0 || monde.ennemis_en_vie.size <= 0
  end

end


class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
 # On n'affiche que les ennemis encore en vie
    ennemis.select {|ennemi| ennemi.en_vie }
  end
end

################################################

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("Balrog"),
  Ennemi.new("Goblin"),
  Ennemi.new("Squelette")
]

# Initialisation du joueur
joueur = Joueur.new("Jean-Michel Paladin")

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

# Boucle de jeu principale
100.times do |tour|
  puts "\n------------------ Tour numéro #{tour} ------------------"

# Affiche les différentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i


  # En fonction du choix on appelle différentes méthodes sur le joueur
  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    # On quitte la boucle de jeu si on a choisi
    # 99 qui veut dire "quitter"
    puts "Vous avez choisi de quitter la partie. A une prochaine fois!"
    break
  elsif choix >= 5 && choix < 99
  	puts "Ce choix n'existe pas."
  	Jeu.actions_possibles(monde)
  else
    # Choix - 2 car nous avons commencé à compter à partir de 2
    # car les choix 0 et 1 étaient réservés pour le soin et
    # l'amélioration d'attaque
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le héros subit une attaque.
    ennemi.attaque(joueur)
  end

  puts "\nEtat du héros: #{joueur.info}\n"

# Si le jeu est fini, on interrompt la boucle
  break if Jeu.est_fini(joueur, monde)
end

puts "\nGame Over!\n"

puts "Le résultat de la partie est :
#{joueur.info} \n
#{monde.ennemis[0].info} \n
#{monde.ennemis[1].info} \n
#{monde.ennemis[2].info} "
