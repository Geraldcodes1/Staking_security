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
