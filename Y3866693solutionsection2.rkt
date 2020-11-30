#lang racket

(define a-game ; This procedure holds everything related to the players
  (lambda (number)
    (begin
      (if (and (>= number 2) (<= number 30)) ;Player chooses number to start with, condition
          (begin ;If the condition returns true
            (display "\n Game Player, you decide to go with number: ")
            (display number)
            (display "\n GREAT!!! \n
If the player wins, then he scores 1 point and
Game Machine will increase player's
account by £1, and deduct £2 from its
account. \n
If the player loses, then he will lose 2 points and Game
Machine will deduct £2 from player's
account, and add £1 in its account. \n
If the player doesn’t have any credit,
the game ends. The player can start a new game by
re-register with a deposit.
Generating a random number is now requested. Game Machine
is about to generate a random number and compare it with
the player's number. \n")
            )
          (begin ;If the condition returns false
            (display "\n Game Player, you decided to go with number: ")
            (display number)
            (display "\n Wrong, number should be a min of £2 and a max of £30")
            (set! number 0)
            )
          )

      ;call using (P1 'randomnum)
      (lambda (request . args) ; Takes 'request' as input, returns one of four procedures
        (begin
          (define (randomnum) ; Procedure returns random number
            (begin
              (define randomNumber (random 2 51)) ; Random number is between 2-50
              (display random)
              (display "\n The random number is: ")
              (display randomNumber)
              (display "\n Game player, your number is: ")
              (display number)
              (if (<= number randomNumber)
                  (display "\n You have lost £2.")
                  (display "\n You have won £1.")
                  )
              )
            )

          ;call using (P1 'decreasemoney)
          (define (decreasemoney) ; If the player loses, run this procedure
            (begin
              (display "\n Previously you had: £")
              (display number)
              (set! number (- number 2)) ; Decrements player number by 2
              (display "\n You now have: £")
              (display number)
              (if (> number 1)
                  (display "\n You still have enough money to play.")
                  (display"\n Sorry, out of credit. Top-up to continue playing.")
                  )
              )
            )
          
          ;call using (P1 'topup X)
          (define (topup t) ; Top-up procedure, ran if player does not have enough money
            (begin
              (set! number (+ number t)) ; Player chooses a value 't' to top-up with
              (display "\n You just topped up: £")
              (display t)
              (display "\n You can play now!")
              )
            )

          ;call using (P1 'increasemoney)
          (define (increasemoney) ; Procedure runs if player wins the game
            (begin
              (display "\n You previously had: £")
              (display number)
              (set! number (+ number 1)) ; Increment player money by 1
              (display "\n You now have: £")
              (display number)
              )
            )

          (cond
            [(eq? request 'randomnum) (randomnum)] ; Procedure to generate a random number
            [(eq? request 'increasemoney) (increasemoney)] ; Procedure if player wins
            [(eq? request 'decreasemoney) (decreasemoney)] ; Procedure if player loses
            [(eq? request 'topup) (begin ;Procedure to top-up
                                    (define t (first args))
                                    (topup t)
                                    )
                                  ]
            [else (display "Unknown request")] ; Returns error if a request is unrecognized
            )
          )
        )
      )
    )
  )


(define game_machine_amount 0) ; Creating a variable, this way player can change 'game_machine_amount' on terminal

(define (game_machine_decrement) ;If player wins, Game Machine loses - run this procedure
  (begin
    (display "\n Game Machine, before you had: £")
    (display game_machine_amount)
    (set! game_machine_amount (- game_machine_amount 2))
    (display "\n You lost, you now have: £")
    (display game_machine_amount)
    )
  (if (> game_machine_amount 1) ; Checks if Game Machine still has enough money to play
      (display "\n Game Machine, there is still enough money to be play.")
      (display "\n Game Machine, there is not enough credit - you need to top-up!")
      )
  )


(define (game_machine_increment) ; If player loses, Game Machine wins - run this procedure
  (begin
    (display "\n Game Machine, before you had: £")
    (display game_machine_amount)
    (set! game_machine_amount (+ game_machine_amount 1))
    (display "\n You won, you now have: £")
    (display game_machine_amount)
    )
  )






  