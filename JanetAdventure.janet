(def player-inventory (array))

(defn has-item? [item]
  (some |(= $ item) player-inventory))

(defn add-to-inventory [item]
  (unless (has-item? item)
    (array/push player-inventory item)))

(defn hidden-chamber [back-fn]
  (if (has-item? "magical key")
    (print "With the key you found, you unlock the hidden chamber and discover an ancient artifact of immense power. Adventure successful.")
    (do
      (print "The chamber is locked. If only you had a key...")
      (back-fn))))


(defn open-chest [back-fn]
  (print "Inside the chest, you find a magical key! Do you take it? (yes/no/back)")
  (var decision (string/trim (file/read stdin :line)))
  (cond
    (= decision "yes") (do
                         (add-to-inventory "magical key")
                         (print "You take the magical key. It might unlock something important.")
                         (back-fn))
    (= decision "no") (print "You leave the key and exit the cave. Adventure over.")
    (= decision "back") (back-fn)))

(defn ancient-library [back-fn]
  (print "You stumble upon an ancient library filled with books. Do you search the books? (yes/no/back)")
  (var decision (string/trim (file/read stdin :line)))
  (cond
    (= decision "yes") (do
                         (print "You discover a book of ancient wisdom. You're now wiser but it's time to head home. Adventure over.")
                         (hidden-chamber back-fn))
    (= decision "no") (print "You leave the library untouched and exit the cave. Adventure over.")
    (= decision "back") (back-fn)))

(defn mysterious-pond [back-fn]
  (print "You find a glowing pond. Its waters shimmer with magical energy. Do you drink from it? (yes/no/back)")
  (var decision (string/trim (file/read stdin :line)))
  (cond
    (= decision "yes") (do
                         (add-to-inventory "magical power")
                         (print "You feel a surge of power. Your adventure takes a magical turn.")
                         (back-fn))
    (= decision "no") (print "You decide not to risk it and continue on your path. Adventure continues...")
    (= decision "back") (back-fn)))


(defn left-path [back-fn]
  (print "You find a treasure chest! Do you open it? (yes/no/back)")
  (var decision (string/trim (file/read stdin :line)))
  (cond
    (= decision "yes") (open-chest back-fn)
    (= decision "no") (print "You leave the chest unopened and exit the cave. Adventure over.")
    (= decision "back") (back-fn)))

(defn right-path [back-fn]
  (print "You encounter a sleeping dragon. Do you try to sneak by, fight, or leave? (sneak/fight/leave/back)")
  (var decision (string/trim (file/read stdin :line)))
  (cond
    (= decision "sneak") (do
                           (print "As you sneak by the dragon, you notice a glint of metal. It's a magical sword!")
                           (add-to-inventory "magical sword")
                           (print "You quietly take the magical sword.")
                           (print "Do you wish to attack the dragon with the sword or go back? (attack/go back)")
                           (var decision2 (string/trim (file/read stdin :line)))
                           (cond
                             (= decision2 "attack") (do
                                                      (print "Emboldened by your new weapon, you turn to face the dragon.")
                                                      (if (or (has-item? "magical power") (has-item? "magical sword"))
                                                        (do
                                                          (print "With the magical sword in hand, you bravely confront and defeat the dragon! "))
                                                        (do
                                                          (print "Despite your valiant effort, the dragon overpowers you. Adventure over."))))
                             (= decision2 "go back") (do
                                                       (print "You decide not to risk the confrontation and continue exploring the cave.")
                                                       (back-fn))))
    (= decision "fight") (if (has-item? "magical power")
                           (do
                             (print "With the magical power you gained, you bravely confront and defeat the dragon! Dragon's treasures are now yours. Adventure over"))
                           (do
                             (print "Without magical power, the dragon awakes and defeats you. Adventure over.")))
    (= decision "leave") (print "You decide not to risk it and go back the way you came. Adventure over.")
    (= decision "back") (back-fn)))


(defn cave-entrance []
  (defn navigate []
    (print "Inside the cave, you see several paths: 'left', 'right', 'straight', 'up', 'down', 'mysterious glow', 'hidden door'. Which do you choose? (or type 'back' to leave)")
    (let [decision (string/trim (file/read stdin :line))]
      (match decision
        "left" (left-path navigate)
        "right" (right-path navigate)
        "straight" (print "You walk straight into a wall. Perhaps not the best decision.")
        "up" (print "You climb up the cave walls and find a small exit. You escape.")
        "down" (print "You find a deep pit. It's too risky to jump.")
        "mysterious glow" (mysterious-pond navigate)
        "hidden door" (do
                        (print "You approach a hidden door.")
                        (hidden-chamber navigate))
        "back" (print "You decide to leave the cave. Adventure over.")
        _ (do
            (print "Invalid input. Please choose a valid direction or type 'back' to leave.")
            (navigate)))))

  (navigate))

(defn start-adventure []
  (print "You find yourself at the entrance of a dark, mysterious cave. Legend says a fierce dragon guards a treasure within. Do you enter to defeat the dragon and claim the treasure? (yes/no)")
  (var decision (string/trim (file/read stdin :line)))
  (if (= decision "yes")
    (do
      (print "Your task is clear: defeat the dragon. You may find help along the way.")
      (cave-entrance))
    (print "You decide not to enter the cave and return home. Adventure over.")))

(start-adventure)