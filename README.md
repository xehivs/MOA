# Dodatki do MOA
##Inkrementowany klasyfikator

Bayesowski:
- Naive Bayes
- Perceptron
- k-NN

###Parametry

- `budget` — % of objects in each chunk
- `treshold` — `[0,1]`
- `chunk_size`

###Algorytm

    while data stream exists
      set budget
      collect data in data chunk
      randomize chunk
      for each object in chunk
        classify(object)
        if budget > 0 && support < treshold
          ask for label
          retrain classifier
          budget--
        end
      end
    end
    end
