(defun gen1 (n last val double low high)
    (if (= n 6)
        (if (and (= double 1) (<= low val) (<= val high))
            1
            0
        )
        (apply '+ (loop for d from (if (= last -1) 0 last) to 9
            collect (if (= d last)
                (gen1 (+ n 1) d (+ (* 10 val) d) 1 low high)
                (gen1 (+ n 1) d (+ (* 10 val) d) double low high)
            )
        ))
    )
)

(defun gen2 (n last len val double low high)
    (if (= n 6)
        (if (and (or (= double 1) (= len 2)) (<= low val) (<= val high))
            1
            0
        )
        (apply '+ (loop for d from (if (= last -1) 0 last) to 9
            collect (if (= d last)
                (gen2 (+ n 1) d (+ len 1) (+ (* 10 val) d) double low high)
                (if (= len 2)
                    (gen2 (+ n 1) d 1 (+ (* 10 val) d) 1 low high)
                    (gen2 (+ n 1) d 1 (+ (* 10 val) d) double low high)
                )
            )
        ))
    )
)

(write-line (write-to-string (gen1 0 -1 0 0 245182 790572)))
(write-line (write-to-string (gen2 0 -1 0 0 0 245182 790572)))
