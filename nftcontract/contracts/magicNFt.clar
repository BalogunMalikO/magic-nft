

;; magicNFt smartcontract
;;implementing the trait 
(impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

;;defineing constants
(define-constant contract-owner tx-sender )
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;;define the token type
(define-non-fungible-token magicNFt uint)
;; seting a token-id variable
(define-data-var last-token-id uint  u0)

;;read only function for token-id
(define-read-only (get-last-token-id )
  (ok (var-get last-token-id))
)
;;read only function token uri
(define-read-only (get-token-uri (token-id uint) )
  (ok none)
)
;;read only function to know token owner
(define-read-only (get-owner (token-id uint) )
   
   (ok (nft-get-owner? magicNFt token-id ) )
 
)
;; transfer function
(define-public (transfer (token-id uint ) (sender principal ) (recipient principal ))
   
   (begin 
   
   ;;make sure the sender of the token is the ownere
    (asserts! (is-eq tx-sender sender ) err-not-token-owner)
     ;; #[filter(token-id, recipient)]
     (nft-transfer? magicNFt token-id sender recipient)



   )
)
;;define a mint function, this function create the NFT
(define-public (mint (recipient principal))

 (let
      (
          ;;this expression increment last token-id by 1
          (token-id (+ (var-get last-token-id) u1))

      )
      ;;make sure the minter is the contract owner
      (asserts! (is-eq tx-sender contract-owner) err-owner-only) 
      ;; #[filter(recipient)]
      (try! (nft-mint? magicNFt token-id recipient ))
      (var-set last-token-id token-id)
      (ok token-id)
    )



)