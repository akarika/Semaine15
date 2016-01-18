
aleatoire = rand(100)
compteur = 1

puts "Rentrez un chiffre entre 0 et 100"
entre = gets.to_i
while aleatoire!= entre
  if entre > 100 || entre < 0
      puts "Entrez un nombre entre 0 et 100 SVP"
    elsif entre < aleatoire
        compteur += 1
        puts "Trop petit. Rentrez un chiffre plus grand:"
        entre = gets.to_i
    elsif entre > aleatoire
        compteur +=1
        puts "Trop grand. Rentrez un chiffre plus petit:"
        entre = gets.to_i
    end
end

puts "C'est gagné! Vous avez trouvé en #{compteur} coup."
