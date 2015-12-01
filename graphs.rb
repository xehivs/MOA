#!/usr/bin/env ruby
# Graphs
require 'colorize'
require 'csv'    
require 'set'

classifiersSet = [ "moa.classifiers.functions.Perceptron", "moa.classifiers.bayes.NaiveBayes", "moa.classifiers.lazy.kNN" ]
generatorsSet = [ "generators.WaveformGeneratorDrift", "generators.RandomTreeGenerator", "generators.LEDGeneratorDrift" ]
chunksSet = [ 100, 1000, 10000, 100000 ]
chunkSizeSet = [ 10, 100, 1000 ]
thresholdSet = [ 0.25, 0.5, 0.75 ]
budgetSet = [ 0.125, 0.25, 0.5, 0.75 ]

#results = CSV.read("results.csv")

CSV.foreach('results.csv') do |row|
  puts row.inspect
end