;; Milestone-Based Crowdfunding Contract
;; Built with Clarity on the Stacks Blockchain

;; Constants for validation
(define-constant ERR-INVALID-GOAL u200)
(define-constant ERR-INVALID-MILESTONES u201)
(define-constant ERR-INVALID-AMOUNT u202)
(define-constant ERR-PROJECT-NOT-FOUND u100)
(define-constant ERR-UNAUTHORIZED u102)
(define-constant ERR-TRANSFER-FAILED u103)
(define-constant MIN-GOAL u1000000) ;; Minimum 1 STX (in microSTX)
(define-constant MIN-PLEDGE u10000) ;; Minimum 0.01 STX (in microSTX)

;; Define next project ID variable
(define-data-var next-project-id uint u1)

;; Define project map with simple uint key
(define-map projects uint {
    owner: principal,
    goal: uint,
    funds-raised: uint,
    milestones: (list 10 uint),
    milestone-status: (list 10 bool),
    completed: bool
})

;; Define backers map using uint project-id and principal as composite key
(define-map backers {
    project-id: uint,
    backer: principal
} {
    amount: uint
})

;; Helper function to validate milestones
(define-private (validate-milestones (milestones (list 10 uint)) (goal uint))
    (let (
        (total-m0 (default-to u0 (element-at milestones u0)))
        (total-m1 (+ total-m0 (default-to u0 (element-at milestones u1))))
        (total-m2 (+ total-m1 (default-to u0 (element-at milestones u2))))
        (total-m3 (+ total-m2 (default-to u0 (element-at milestones u3))))
        (total-m4 (+ total-m3 (default-to u0 (element-at milestones u4))))
        (total-m5 (+ total-m4 (default-to u0 (element-at milestones u5))))
        (total-m6 (+ total-m5 (default-to u0 (element-at milestones u6))))
        (total-m7 (+ total-m6 (default-to u0 (element-at milestones u7))))
        (total-m8 (+ total-m7 (default-to u0 (element-at milestones u8))))
        (total-m9 (+ total-m8 (default-to u0 (element-at milestones u9))))
    )
        (and 
            ;; Check that milestones sum up to goal
            (is-eq total-m9 goal)
            ;; Check that we have at least one milestone with a non-zero amount
            (> total-m9 u0)
        )
    )
)

;; Helper function to update a specific milestone status at index
(define-private (update-milestone-status (status (list 10 bool)) (index uint))
    (if (is-eq index u0)
        (list true (unwrap-panic (element-at status u1)) (unwrap-panic (element-at status u2)) 
              (unwrap-panic (element-at status u3)) (unwrap-panic (element-at status u4)) 
              (unwrap-panic (element-at status u5)) (unwrap-panic (element-at status u6)) 
              (unwrap-panic (element-at status u7)) (unwrap-panic (element-at status u8)) 
              (unwrap-panic (element-at status u9)))
    (if (is-eq index u1)
        (list (unwrap-panic (element-at status u0)) true (unwrap-panic (element-at status u2))
              (unwrap-panic (element-at status u3)) (unwrap-panic (element-at status u4))
              (unwrap-panic (element-at status u5)) (unwrap-panic (element-at status u6))
              (unwrap-panic (element-at status u7)) (unwrap-panic (element-at status u8))
              (unwrap-panic (element-at status u9)))
    (if (is-eq index u2)
        (list (unwrap-panic (element-at status u0)) (unwrap-panic (element-at status u1)) true
              (unwrap-panic (element-at status u3)) (unwrap-panic (element-at status u4))
              (unwrap-panic (element-at status u5)) (unwrap-panic (element-at status u6))
              (unwrap-panic (element-at status u7)) (unwrap-panic (element-at status u8))
              (unwrap-panic (element-at status u9)))
    (if (is-eq index u3)
        (list (unwrap-panic (element-at status u0)) (unwrap-panic (element-at status u1)) 
              (unwrap-panic (element-at status u2)) true (unwrap-panic (element-at status u4))
              (unwrap-panic (element-at status u5)) (unwrap-panic (element-at status u6))
              (unwrap-panic (element-at status u7)) (unwrap-panic (element-at status u8))
              (unwrap-panic (element-at status u9)))
    (if (is-eq index u4)
        (list (unwrap-panic (element-at status u0)) (unwrap-panic (element-at status u1)) 
              (unwrap-panic (element-at status u2)) (unwrap-panic (element-at status u3)) true
              (unwrap-panic (element-at status u5)) (unwrap-panic (element-at status u6))
              (unwrap-panic (element-at status u7)) (unwrap-panic (element-at status u8))
              (unwrap-panic (element-at status u9)))
    (if (is-eq index u5)
        (list (unwrap-panic (element-at status u0)) (unwrap-panic (element-at status u1)) 
              (unwrap-panic (element-at status u2)) (unwrap-panic (element-at status u3))
              (unwrap-panic (element-at status u4)) true (unwrap-panic (element-at status u6))
              (unwrap-panic (element-at status u7)) (unwrap-panic (element-at status u8))
              (unwrap-panic (element-at status u9)))
    (if (is-eq index u6)
        (list (unwrap-panic (element-at status u0)) (unwrap-panic (element-at status u1)) 
              (unwrap-panic (element-at status u2)) (unwrap-panic (element-at status u3))
              (unwrap-panic (element-at status u4)) (unwrap-panic (element-at status u5)) true
              (unwrap-panic (element-at status u7)) (unwrap-panic (element-at status u8))
              (unwrap-panic (element-at status u9)))
    (if (is-eq index u7)
        (list (unwrap-panic (element-at status u0)) (unwrap-panic (element-at status u1)) 
              (unwrap-panic (element-at status u2)) (unwrap-panic (element-at status u3))
              (unwrap-panic (element-at status u4)) (unwrap-panic (element-at status u5))
              (unwrap-panic (element-at status u6)) true (unwrap-panic (element-at status u8))
              (unwrap-panic (element-at status u9)))
    (if (is-eq index u8)
        (list (unwrap-panic (element-at status u0)) (unwrap-panic (element-at status u1)) 
              (unwrap-panic (element-at status u2)) (unwrap-panic (element-at status u3))
              (unwrap-panic (element-at status u4)) (unwrap-panic (element-at status u5))
              (unwrap-panic (element-at status u6)) (unwrap-panic (element-at status u7)) true
              (unwrap-panic (element-at status u9)))
    (if (is-eq index u9)
        (list (unwrap-panic (element-at status u0)) (unwrap-panic (element-at status u1)) 
              (unwrap-panic (element-at status u2)) (unwrap-panic (element-at status u3))
              (unwrap-panic (element-at status u4)) (unwrap-panic (element-at status u5))
              (unwrap-panic (element-at status u6)) (unwrap-panic (element-at status u7))
              (unwrap-panic (element-at status u8)) true)
        status)))))))))
    )
)

;; Function to create a new project
(define-public (create-project (goal uint) (milestones (list 10 uint)))
    ;; Validate goal and milestones
    (if (< goal MIN-GOAL)
        (err ERR-INVALID-GOAL)
        (let (
            ;; Create validated copies of input variables
            (validated-goal goal)
            (validated-milestones milestones)
        )
            (if (not (validate-milestones validated-milestones validated-goal))
                (err ERR-INVALID-MILESTONES)
                (let ((project-id (var-get next-project-id)))
                    (begin
                        (map-set projects
                            project-id
                            {
                                owner: tx-sender,
                                goal: validated-goal,
                                funds-raised: u0,
                                milestones: validated-milestones,
                                milestone-status: (list false false false false false false false false false false),
                                completed: false
                            }
                        )
                        (var-set next-project-id (+ project-id u1))
                        (ok project-id)
                    )
                )
            )
        )
    )
)

;; Function to pledge funds to a project
(define-public (pledge (project-id uint) (amount uint))
    ;; Validate pledge amount
    (if (< amount MIN-PLEDGE)
        (err ERR-INVALID-AMOUNT)
        (let ((project (map-get? projects project-id)))
            (if (is-some project)
                (let ((proj-data (unwrap! project (err ERR-PROJECT-NOT-FOUND)))
                      (current-funds (get funds-raised proj-data))
                      (validated-amount amount)) ;; Create a validated copy of amount
                    (begin
                        ;; Store backer information
                        (map-set backers 
                            {
                                project-id: project-id,
                                backer: tx-sender
                            }
                            {amount: validated-amount}
                        )
                        ;; Update project funds
                        (map-set projects 
                            project-id
                            (merge proj-data {funds-raised: (+ current-funds validated-amount)})
                        )
                        (ok true)
                    )
                )
                (err ERR-PROJECT-NOT-FOUND) ;; Error: Project not found
            )
        )
    )
)

;; Function to release funds for a completed milestone
(define-public (release-funds (project-id uint) (milestone-index uint))
    (let ((project (map-get? projects project-id)))
        (if (is-some project)
            (let ((proj-data (unwrap! project (err ERR-PROJECT-NOT-FOUND)))
                  (owner (get owner proj-data))
                  (milestone-list (get milestones proj-data))
                  (milestone-status (get milestone-status proj-data)))
                (if (and (is-eq owner tx-sender)
                         (not (unwrap-panic (element-at milestone-status milestone-index))))
                    (let ((milestone-amount (unwrap-panic (element-at milestone-list milestone-index))))
                        (begin
                            ;; Update milestone status using helper function
                            (map-set projects 
                                project-id
                                (merge proj-data {
                                    milestone-status: (update-milestone-status milestone-status milestone-index)
                                })
                            )
                            ;; Transfer STX to project owner and check result
                            (match (stx-transfer? milestone-amount tx-sender owner)
                                success (ok true)
                                error (err ERR-TRANSFER-FAILED)
                            )
                        )
                    )
                    (err ERR-UNAUTHORIZED) ;; Error: Not authorized or milestone already completed
                )
            )
            (err ERR-PROJECT-NOT-FOUND) ;; Error: Project not found
        )
    )
)