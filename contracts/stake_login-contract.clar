(define-map stakers {user: principal} {password-hash: (buff 32), remember-token: (optional (buff 32)), oauth-token: (optional (buff 32)), failed-attempts: uint, locked: bool})

(define-public (register (user principal) (password-hash (buff 32)))
    (begin
        (if (map-get? stakers {user: user})
            (err "User already registered")
            (begin
                (map-set stakers {user: user} {password-hash: password-hash, remember-token: none, oauth-token: none, failed-attempts: u0, locked: false})
                (ok "Registration successful")))))

(define-public (authenticate (user principal) (password-hash (buff 32)))
    (match (map-get? stakers {user: user})
        some-record 
        (if (is-eq password-hash (get password-hash some-record))
            (ok "Authentication successful")
            (err "Invalid credentials"))
        (err "User not found")))

(define-public (update-password (user principal) (old-password-hash (buff 32)) (new-password-hash (buff 32)))
    (match (map-get? stakers {user: user})
        some-record 
        (if (is-eq old-password-hash (get password-hash some-record))
            (begin
                (map-set stakers {user: user} {password-hash: new-password-hash})
                (ok "Password updated successfully"))
            (err "Invalid old password"))
        (err "User not found")))
(define-constant MAX-ATTEMPTS 3)

(define-public (authenticate (user principal) (password-hash (buff 32)))
    (match (map-get? stakers {user: user})
        some-record 
        (if (is-eq (get locked some-record) true)
            (err "Account locked due to multiple failed attempts")
            (if (is-eq password-hash (get password-hash some-record))
                (begin
                    (map-set stakers {user: user} {password-hash: get password-hash some-record, failed-attempts: u0, locked: false})
                    (ok "Authentication successful"))
                (let ((new-attempts (+ (get failed-attempts some-record) u1)))
                    (if (>= new-attempts MAX-ATTEMPTS)
                        (begin
                            (map-set stakers {user: user} {failed-attempts: new-attempts, locked: true})
                            (err "Account locked due to multiple failed attempts"))
                        (begin
                            (map-set stakers {user: user} {failed-attempts: new-attempts})
                            (err "Invalid credentials"))))))))
        (err "User not found")))

(define-public (unlock-account (user principal))
    (match (map-get? stakers {user: user})
        some-record
        (begin
            (map-set stakers {user: user} {failed-attempts: u0, locked: false})
            (ok "Account unlocked")))
        (err "User not found")))
(define-public (set-remember-me (user principal) (token (buff 32)))
    (match (map-get? stakers {user: user})
        some-record
        (begin
            (map-set stakers {user: user} {password-hash: get password-hash some-record, remember-token: (some token), oauth-token: get oauth-token some-record, failed-attempts: get failed-attempts some-record, locked: get locked some-record})
            (ok "Remember me token set")))
        (err "User not found")))

(define-public (set-oauth-token (user principal) (token (buff 32)))
    (match (map-get? stakers {user: user})
        some-record
        (begin
            (map-set stakers {user: user} {password-hash: get password-hash some-record, remember-token: get remember-token some-record, oauth-token: (some token), failed-attempts: get failed-attempts some-record, locked: get locked some-record})
            (ok "OAuth token set")))
        (err "User not found")))
