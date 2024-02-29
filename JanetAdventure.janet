(def player-inventory (array))

(defn has-key? []
  (some |(= $ "magical key") player-inventory))

(defn add-key-to-inventory []
  (array/push player-inventory "magical key"))

(defn hidden-chamber [back-fn]
  (if (has-key?)
    (print "With the key you found, you unlock the hidden chamber and discover an ancient artifact of immense power. Adventure successful.")
    (do
      (print "The chamber is locked. If only you had a key...")
      (back-fn))))


(defn open-chest [back-fn]
  (print "Inside the chest, you find a magical key! Do you take it? (yes/no/back)")
  (var decision (string/trim (file/read stdin :line)))
  (cond
    (= decision "yes") (do
                         (add-key-to-inventory)
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
                         (print "You feel a surge of power. Your adventure takes a magical turn.")
                         (ancient-library back-fn))
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
  (print "You encounter a sleeping dragon. Do you try to sneak by or leave? (sneak/leave/back)")
  (var decision (string/trim (file/read stdin :line)))
  (cond
    (= decision "sneak") (mysterious-pond back-fn)
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
  (print "You find yourself at the entrance of a dark, mysterious cave. Do you enter? (yes/no)")
  (var decision (string/trim (file/read stdin :line)))
  (if (= decision "yes")
    (cave-entrance)
    (print "You decide not to enter the cave and return home. Adventure over.")))

(start-adventure)