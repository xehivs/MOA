#!/usr/bin/env ruby
# Skrypt
require 'colorize'
require 'csv'    
require 'set'
#require 'chartkick'
#require 'erb'
#require 'jquery'

module Enumerable
    def sum
      self.inject(0){|accum, i| accum + i }
    end

    def mean
      self.sum/self.length.to_f
    end

    def sample_variance
      m = self.mean
      sum = self.inject(0){|accum, i| accum +(i-m)**2 }
      sum/(self.length - 1).to_f
    end

    def standard_deviation
      return Math.sqrt(self.sample_variance)
    end
end 

classifiersSet = [ "moa.classifiers.functions.Perceptron", "moa.classifiers.bayes.NaiveBayes" ]
generatorsSet = [ "generators.WaveformGeneratorDrift", "generators.RandomTreeGenerator" ]

chunksSet = [ 100, 1000 ]
chunkSizeSet = [ 10, 100 ]
thresholdSet = [ 0.25, 0.5 ]
budgetSet = [ 0.125, 0.25 ]

experimentsCount = generatorsSet.length * classifiersSet.length * chunksSet.length * chunkSizeSet.length * thresholdSet.length * budgetSet.length
experimentNumber = 0

results = Set.new

for classifier in classifiersSet
for generator in generatorsSet
for chunks in chunksSet
for chunkSize in chunkSizeSet
for threshold in thresholdSet
for budget in budgetSet
	experimentNumber += 1
	classifierName = classifier.split('.').last.downcase
	generatorName = generator.split('.').last.downcase

	outputFilename = "results/#{classifierName}_#{generatorName}_i_#{chunks}_s_#{chunkSize}_t_#{threshold}_b_#{budget}.csv"
	puts "# [#{experimentNumber}/#{experimentsCount}][#{(100*experimentNumber/experimentsCount).round}%]".red

	csv_text = File.read(outputFilename)
	csv = CSV.parse(csv_text, :headers => true)
	
	accuracies = Set.new;
	csv.each do |row|
		accuracy = row[4]
		accuracies.add(accuracy.to_f)
	end

	result = { :classifier => classifier, :generator => generator, :chunks => chunks, :chunkSize => chunkSize, :threshold => threshold, :budget => budget, :meanAccuracy => accuracies.mean, :standardDeviation => accuracies.standard_deviation }
	results.add result
end
end
end
end
end
end

# do wyboru classifier i generator
# zewnętrzny poziom wykresu chunks od chunk size
# wewnętrzny poziom wykresu budget od threshold
# accuracy od budget
# kolejne linie do treshold

classifier = classifiersSet[0]
generator = generatorsSet[0]
chunks = chunksSet[0]
chunkSize = chunkSizeSet[0]

CSV.open("results.csv", "wb") do |csv|
	for result in results
		csv << result.values
	end
end