# Staking Security Contract

## Overview
This Clarity smart contract provides a secure authentication system for stakers. It includes features such as user registration, login authentication, password updates, and security mechanisms like account lockouts and OAuth authentication.

## Features
- **User Registration**: Allows users to register with a hashed password.
- **Login Authentication**: Verifies user credentials securely.
- **Remember Me Token**: Stores an optional token for persistent login sessions.
- **OAuth Support**: Allows authentication via OAuth tokens.
- **Account Lockout**: Locks accounts after multiple failed login attempts.
- **Password Updates**: Allows users to change their password securely.
- **Account Unlocking**: Admins or recovery mechanisms can unlock accounts.

## Functions

### `register(user principal, password-hash (buff 32)) -> (ok | err)`
Registers a new user with a hashed password.

### `authenticate(user principal, password-hash (buff 32)) -> (ok | err)`
Validates user credentials. Locks account after exceeding max failed attempts.

### `update-password(user principal, old-password-hash (buff 32), new-password-hash (buff 32)) -> (ok | err)`
Allows users to update their password securely.

### `set-remember-me(user principal, token (buff 32)) -> (ok | err)`
Stores a "remember me" token for persistent authentication.

### `set-oauth-token(user principal, token (buff 32)) -> (ok | err)`
Enables authentication via OAuth.

### `unlock-account(user principal) -> (ok | err)`
Unlocks an account after a lockout.

## Security Measures
- Passwords are stored as hashed values.
- Accounts are locked after repeated failed login attempts.
- OAuth tokens provide alternative authentication mechanisms.
- Users can update passwords securely without exposing credentials.

## Deployment
This contract can be deployed on the Stacks blockchain using Clarinet:
```sh
clarinet check
clarinet test
clarinet deploy
```

## License
This project is licensed under the MIT License.

