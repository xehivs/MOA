#!/usr/bin/env ruby
# Skrypt
require 'colorize'
require 'csv'    
require 'set'
require 'json'

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

config = JSON.parse(File.read('config.json'))

classifiersSet = config["classifiersSet"]
generatorsSet = config["generatorsSet"]
chunksSet = config["chunksSet"]
chunkSizeSet = config["chunkSizeSet"]
thresholdSet = config["thresholdSet"]
budgetSet = config["budgetSet"]
timeCut = config["timeCut"]

experimentsCount = generatorsSet.length * classifiersSet.length * chunksSet.length * chunkSizeSet.length * thresholdSet.length * budgetSet.length
experimentNumber = 0

results = Array.new

header = { :classifier => "classifier", :generator => "generator", :chunks => "chunks", :chunkSize => "chunkSize", :threshold => "threshold", :budget => "budget", :meanAccuracy => "meanAccuracy", :standardDeviation => "standardDeviation" }

results << header

for chunks in chunksSet
for chunkSize in chunkSizeSet
for threshold in thresholdSet
for classifier in classifiersSet
for generator in generatorsSet
for budget in budgetSet
	experimentNumber += 1

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

    if experimentNumber % 100 == 0
        puts "experiment #{experimentNumber}".green
    end
	if accuracies.length == 0
		puts "# [#{experimentNumber}/#{experimentsCount}][#{(100*experimentNumber/experimentsCount).round}%]".red
	else
#		puts "# [#{experimentNumber} good]".green
	end

	result = { :classifier => classifier, :generator => generator, :chunks => chunks, :chunkSize => chunkSize, :threshold => threshold, :budget => budget, :meanAccuracy => accuracies.mean, :standardDeviation => accuracies.standard_deviation }
	results << result
end
end
end
end
end
end

CSV.open("results.csv", "wb") do |csv|
	for result in results
		csv << result.values
		#puts result.to_json
	end
end



#File.open('results.json', "wb") { |f| f.write(results.to_json) }

# Wszystko dla każdego z trzech generatorów

# Accuracy dla
