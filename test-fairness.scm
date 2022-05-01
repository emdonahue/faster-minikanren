

; Both fair and normal fresh handle this correctly
(test "fail conj"
      (run* (q)	
	((rec diverge
	      (lambda ()
		(fair-fresh ()
			    (== 1 2)
			    (diverge))))))
      '())

; Would diverge with normal fresh diverge but doesn't
(test "diverge conj"
      (run* (q)	
	((rec diverge
	      (lambda ()
		(fair-fresh ()			    
			    (diverge)
			    (== 1 2))))))
      '())

; Uses normal fresh and diverges
#;(test "diverge conj"
      (run* (q)	
	((rec diverge
	      (lambda ()
		(fresh ()			    
			    (diverge)
			    (== 1 2))))))
      '())

; Increments a counter so we never see the same argument inputs, in case we wanted to try implementing fairness using some kind of memoization, but still converges
(test "increment diverge"
      (run* (q)	
	((rec diverge
	      (lambda (x)
		(fair-fresh ()			    
			    (diverge (+ x 1))
			    (== 1 2)))) 0))
      '())

; Divergent branches fail normally without harming the rest of the search
(test "all branches converge"
      (run* (q)
	(conde
	  [(== q 1)]
	  [((rec diverge
		 (lambda ()
		   (fair-fresh ()			    
			       (diverge)
			       (== 1 2)))))]
	  [(== q 2)]))
      '(1 2))

; Any number of branches can diverge
(test "find all divergence"
      (run* (q)
	(conde
	  [((rec diverge
		 (lambda ()
		   (fair-fresh ()			    
			       (diverge)
			       (== 1 2)))))]
	  [((rec diverge
		 (lambda ()
		   (fair-fresh ()			    
			       (diverge)
			       (== 1 2)))))]))
      '())

; Any number of conjuncts can diverge
(test "conjoined divergences"
      (run* (q)
	((rec diverge
	      (lambda ()
		(fair-fresh ()			    
			    (diverge)
			    (== 1 2)))))
	((rec diverge
	      (lambda ()
		(fair-fresh ()			    
			    (diverge)
			    (== 1 2))))))
      '())
