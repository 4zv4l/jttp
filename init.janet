(def HTTP_200 "HTTP/1.1 200 OK\r\n\r\n")
(def HTTP_404 "HTTP/1.1 404 NOT FOUND\r\n\r\nNot Found...")

(defn handle [client]
  (defer (do (:shutdown client) (:close client))
    (try
      (match (->> (:read client 128) (string/split "\n") (first) (string/trim) (string/split " "))
        ["GET" path "HTTP/1.1"] (do
                                  (def path (string "." path))
                                  (printf "GET %s HTTP/1.1" path)
                                  (if (string/has-suffix? "/" path)
                                    (:write client (string HTTP_200 (slurp (string path "index.html"))))
                                    (:write client (string HTTP_200 (slurp path)))))
        else (eprintf "Todo received: %q" else))
      ([err] (:write client HTTP_404)))))

(defn main [& args] (net/server "127.0.0.1" 8080 handle))
