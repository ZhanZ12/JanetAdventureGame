#-------Done by Mussin Assyltas and Zhunussov Zhan-----
#
#This code to 'clear' the screen
(defn clear-screen []
  (print (string/repeat "\n" 100))) 

#Condintion to determine if the game is over
(var game-over? false)

#Player inventory
(def player-inventory (array))

#Check if player has the required item for different scenarios
(defn has-item? [item]
  (some |(= $ item) player-inventory))

#Check if the player has the required magic
(defn has-magical-power? []
  (some |(= $ "magical power") player-inventory))

#Adds the item/power to inventory
(defn add-to-inventory [item]
  (unless (has-item? item)
    (array/push player-inventory item)))


#Hidden chamber accessable in the entrance behind 'hidden door'
(defn hidden-chamber [back-fn]
  (if (has-item? "magical key")
    (do
      (print "\n \n With the key you found, you unlock the hidden chamber and discover magical armor of immense power.")
      (add-to-inventory "magical armor")
      (print "\n \n You take the magical armor, feeling its protective power surround you.")
      (back-fn))
    (do
      (print "\n \n The chamber is locked. If only you had a key...")
      (back-fn))))


#Ancient library
(defn ancient-library [back-fn]
  (var decision "")
  (while (not (or (= decision "yes") (= decision "no") (= decision "back")))
    (print "\n \n You stumble upon an ancient library filled with books. Do you search the books? (yes/no/back)")
    (var decision (string/trim (file/read stdin :line)))
    (cond
      (= decision "yes") (do
                           (print "\n \n \n \n You discover a book of ancient wisdom. You now have the knowledge to defeat the Dragon. You have realised you need the legendary armor and sword. Armor is behind the secret chamber, as for the sword the Dragon himself is keeping it near his treasures. \n") (back-fn)
                           (= decision "no") (print "\n \n You leave the library untouched and exit the cave. MAybe one day you will be able to defeat the Dragon. Adventure over.")
                           (= decision "back") (back-fn))))
  :else
  (do
    (print "\n \n Invalid input. Please choose 'yes', 'no', or 'back'.")
    (set decision "")))

#Mysterios pond, behind the glow
(defn mysterious-pond [back-fn]
  (var decision "")
  (while (not (or (= decision "yes") (= decision "no") (= decision "back")))
    (print "\n \n You find a glowing pond. Its waters shimmer with magical energy. Do you drink from it? (yes/no/back)")
    (var decision (string/trim (file/read stdin :line)))
    (cond
      (= decision "yes") (do
                           (array/push player-inventory "magical power")
                           (print "\n \n You feel a surge of power. Your adventure takes a magical turn.")
                           (back-fn))
      (= decision "no") (print "\n \n You decide not to risk it and continue on your path. Adventure continues...") (back-fn)
      (= decision "back") (back-fn)))
  :else
  (do
    (print "\n \n Invalid input. Please choose 'yes', 'no', or 'back'.")
    (set decision "")))


(defn open-chest []
  (print "\n \n As you approach the chest, it magically opens on its own, revealing a glowing magical key inside.")
  (add-to-inventory "magical key")
  (print "\n \n The magical key has been added to your inventory. It might unlock something important."))

#Left path
(defn left-path [back-fn]
  (var decision "")
  (while (not (or (= decision "yes") (= decision "no")))
    (print "\n \n You find a treasure chest! Do you open it? (yes/no)")
    (set decision (string/trim (file/read stdin :line)))
    (cond
      (= decision "yes")
      (do
        (open-chest) 
        (back-fn) 
      )
      (= decision "no")
      (do
        (print "\n \n You leave the chest unopened.")
        (back-fn) 
      )
      :else
      (print "\n \n Invalid input. Please choose 'yes' or 'no'.")
    )))

#Right path
(defn right-path [back-fn]
  (var decision "")
  (while (not (or (= decision "sneak") (= decision "fight") (= decision "leave") (= decision "back") game-over?))
    (do
      (print "\n \n You encounter a sleeping dragon. Do you try to sneak by, fight, or leave? (sneak/fight/leave/back)")
      (set decision (string/trim (file/read stdin :line)))
      (cond
        (= decision "sneak")
        (do
          (print "\n \n As you sneak by the dragon, you notice a glint of metal. It's a magical sword!")
          (add-to-inventory "magical sword")
          (print "\n \n You quietly take the magical sword and leave the Dragon.")
          (back-fn))

        (= decision "fight")
        (if (not (has-item? "magical armor"))
          (do
            (print "\n \n Without the magical armor, the dragon's fiery breath overwhelms you. Though you fought bravely and defeated it, you too succumb to your wounds. Adventure over.")
            (set game-over? true))
          (if (and (not (has-item? "magical sword")) (not (has-item? "magical power")))
            (do
              (print "\n \n Clad in magical armor, you withstand the dragon's flames but, lacking a weapon or magical power, you cannot defeat the dragon. In the end, the dragon overpowers you. Adventure over.")
              (set game-over? true))
            (if (has-item? "magical sword")
              (do
                (print "\n \n Clad in magical armor and wielding the magical sword, you engage the dragon in a fierce battle. The armor protects you from the dragon's fiery breath, and with a mighty swing of your sword, you defeat the dragon. You emerge victorious, with barely a scratch on you.")
                (set game-over? true))
              (if (has-item? "magical power")
                (do
                  (array/remove player-inventory "magical power")
                  (print "\n \n Protected by the magical armor, you channel the one-time magical power against the dragon. A surge of energy flows through you, unleashing a devastating attack that leaves the dragon defeated, while the armor shields you from harm.")
                  (set game-over? true))))))
        (= decision "leave")
        (do
          (print "\n \n You decide not to risk it and go back the way you came. Perhaps another day you will be ready to face the dragon.")
          (set game-over? true))

        (= decision "back")
        (back-fn)

        :else
        (do
          (print "\n \n Invalid input. Please choose 'sneak', 'fight', 'leave', or 'back'.")
          (set decision ""))))))

#Cave entrance
(defn cave-entrance []
  (defn navigate []
    (unless game-over?
      (print "\n \n Inside the cave, you see several paths: 'left', 'right', 'straight', 'up', 'down', 'mysterious glow', 'hidden door'. Which do you choose? (or type 'back' to leave)")
      (let [decision (string/trim (file/read stdin :line))]
        (match decision
          "left" (left-path navigate)
          "right" (right-path navigate)
          "straight" (print "\n \n You walk straight into a wall. Perhaps not the best decision.")

          "up" (do
                 (print "\n \n As you climb up the narrow path, you stumble upon an ancient library hidden within the cave.")
                 (ancient-library navigate))
          "down" (do
               (print "\n \n You find a deep pit. It looks too risky to jump. Do you jump? (yes/no)")
               (var decision (string/trim (file/read stdin :line)))
               (if (= decision "yes")
                 (do
                   (print "\n \n You decide to jump, but unfortunately, it was too risky. You did not survive the fall. Adventure over.")
                   (set game-over? true))
                 (print "\n \n You decide it's too risky and step back, choosing another path."))(cave-entrance))

          "mysterious glow" (mysterious-pond navigate)

          "hidden door" (do
                          (if (has-item? "magical power")
                            (do
                              (print "\n \n Using your magical power, you break down the hidden door and discover the chamber!")
                              (hidden-chamber navigate))
                            (if (has-item? "magical key")
                              (do
                                (print "\n \n You use the key to unlock the hidden chamber.")
                                (hidden-chamber navigate))
                              (do
                                (print "\n \n The door is locked, and you lack the strength to break it. If only you had a key or some magical power...")
                                (navigate)))))
          "back" (print "\n \n You decide to leave the cave. Adventure over.")
          _ (do
              (print "\n \n Invalid input. Please choose a valid direction or type 'back' to leave.")
              (navigate))))))

  (navigate))

#Start
(defn start-adventure []
  (clear-screen)
  (var decision "")
  (while (not (or (= decision "yes") (= decision "no")))
    (do
      (print "\n \n You find yourself at the entrance of a dark, mysterious cave. Legend says a fierce dragon guards a treasure within. Do you enter to defeat the dragon and claim the treasure? (yes/no)")
      (set decision (string/trim (file/read stdin :line)))
      (cond
        (= decision "yes")
        (do
          (print "\n \n Your task is clear: defeat the dragon. You may find help along the way.")
          (cave-entrance))

        (= decision "no")
        (print "\n \n You decide not to enter the cave and return home. Adventure over.")
        :else
        (print "\n \n Invalid input. Please type 'yes' or 'no'.")))))

(start-adventure)
