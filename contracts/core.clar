(use-trait proposal-trait .proposal-trait.proposal-trait)
(use-trait extension-trait .extension-trait.extension-trait)

;;Error Handling and State Management
(define-constant ERR_UNAUTHORIZED (err u1000))
(define-constant ERR_ALREADY_EXECUTED (err u1001))
(define-constant ERR_INVALID_EXTENSION (err u1002))

(define-data-var executive principal tx-sender)
(define-map executedProposals principal uint)
(define-map extensions principal bool)
;;Error Handling and State Management End.

;;Authorization Check
(define-private (is-self-or-extension)
  (ok (asserts! (or (is-eq tx-sender (as-contract tx-sender)) (is-extension contract-caller)) ERR_UNAUTHORIZED))
)

(define-read-only (is-extension (extension principal))
  (default-to false (map-get? extensions extension))
)

(define-read-only (executed-at (proposal <proposal-trait>))
  (map-get? executedProposals (contract-of proposal))
)
;;Authorization Check End.

;;Extension Management
(define-public (set-extension (extension principal) (enabled bool))
  (begin
    (try! (is-self-or-extension))
    (print {event: "extension", extension: extension, enabled: enabled})
    (ok (map-set extensions extension enabled))
  )
)
;;Extension Management End.

;;Proposal Execution
(define-public (execute (proposal <proposal-trait>) (sender principal))
  (begin
    (try! (is-self-or-extension))
    (asserts! (map-insert executedProposals (contract-of proposal) block-height) ERR_ALREADY_EXECUTED)
    (print {event: "execute", proposal: proposal})
    (as-contract (contract-call? proposal execute sender))
  )
)
;;Proposal Execution End.

;;Bootstrap
(define-public (construct (proposal <proposal-trait>))
  (let
    (
      (sender tx-sender)
    )
    (asserts! (is-eq sender (var-get executive)) ERR_UNAUTHORIZED)
    (var-set executive (as-contract tx-sender))
    ;; (as-contract (contract-call? .core set-extension
    ;;        (list
    ;;         {extension: .membership-token, enabled: true}
    ;;         {extension: .proposal-voting, enabled: true}
    ;;         {extension: .proposal-submission, enabled: true})))
    (as-contract (execute proposal sender))
    ;; Distribute initial token allocation to addresses responsible for voting on grants.
    ;; (as-contract (contract-call? .membership-token mint

    ;;         {amount: u1000, recipient: 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5}
	;; 		))
    
  )
)
;;Bootstrap End.

;;Extension Requests
(define-public (request-extension-callback (extension <extension-trait>) (memo (buff 34)))
  (let
    (
      (sender tx-sender)
    )
    (asserts! (is-extension contract-caller) ERR_INVALID_EXTENSION)
    (asserts! (is-eq contract-caller (contract-of extension)) ERR_INVALID_EXTENSION)
    (as-contract (contract-call? extension callback sender memo))
  )
)
;;Extension Requests End.


;; title: core
;; version:
;; summary:
;; description:

;; traits
;;

;; token definitions
;;

;; constants
;;

;; data vars
;;

;; data maps
;;

;; public functions
;;

;; read only functions
;;

;; private functions
;;

