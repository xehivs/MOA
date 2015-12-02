#!/usr/bin/env ruby
# Skrypt
require 'colorize'
require 'csv'    
require 'set'

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

classifiersSet = [ "moa.classifiers.functions.Perceptron", "moa.classifiers.bayes.NaiveBayes", "moa.classifiers.lazy.kNN" ]
generatorsSet = [ "generators.WaveformGeneratorDrift", "generators.RandomTreeGenerator", "generators.LEDGeneratorDrift" ]
chunksSet = [ 100, 1000, 10000, 100000 ]
chunkSizeSet = [ 10, 100, 1000 ]
thresholdSet = [ 0.25, 0.5, 0.75 ]
budgetSet = [ 0.125, 0.25, 0.5, 0.75 ]

experimentsCount = generatorsSet.length * classifiersSet.length * chunksSet.length * chunkSizeSet.length * thresholdSet.length * budgetSet.length
experimentNumber = 0

results = Set.new

header = { :classifier => "classifier", :generator => "generator", :chunks => "chunks", :chunkSize => "chunkSize", :threshold => "threshold", :budget => "budget", :meanAccuracy => "meanAccuracy", :standardDeviation => "standardDeviation" }

results.add header

for chunks in chunksSet
for chunkSize in chunkSizeSet
for threshold in thresholdSet
for classifier in classifiersSet
for generator in generatorsSet
for budget in budgetSet
	experimentNumber += 1
	#if experimentNumber <1250
	#	next
	#end

	classifierName = classifier.split('.').last.downcase
	generatorName = generator.split('.').last.downcase

	outputFilename = "results/#{classifierName}_#{generatorName}_i_#{chunks}_s_#{chunkSize}_t_#{threshold}_b_#{budget}.csv"


	csv_text = File.read(outputFilename)
	csv = CSV.parse(csv_text, :headers => true)
	
	accuracies = Set.new;
	csv.each do |row|
		accuracy = row[4]
		accuracies.add(accuracy.to_f)
	end


	if accuracies.length == 0
		puts "# [#{experimentNumber}/#{experimentsCount}][#{(100*experimentNumber/experimentsCount).round}%]".red
	else
		puts "# [#{experimentNumber} good]".green
	end

	result = { :classifier => classifier, :generator => generator, :chunks => chunks, :chunkSize => chunkSize, :threshold => threshold, :budget => budget, :meanAccuracy => accuracies.mean, :standardDeviation => accuracies.standard_deviation }
	results.add result
end
end
end
end
end
end

CSV.open("results.csv", "wb") do |csv|
	for result in results
		csv << result.values
	end
end
