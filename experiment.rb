#!/usr/bin/env ruby
# Skrypt
require 'colorize'
require 'json'
require 'open-uri'

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

startsWith = ARGV[0] ? ARGV[0].to_i : 0
endsWith = ARGV[1] ? ARGV[1].to_i : experimentsCount

for chunks in chunksSet
for chunkSize in chunkSizeSet
for threshold in thresholdSet
for classifier in classifiersSet
for generator in generatorsSet
for budget in budgetSet
	experimentNumber += 1
	if(experimentNumber < startsWith || experimentNumber > endsWith) 
		next
	end

	classifierName = classifier.split('.').last.downcase
	generatorName = generator.split('.').last.downcase
	outputFilename = "#{classifierName}_#{generatorName}_i_#{chunks}_s_#{chunkSize}_t_#{threshold}_b_#{budget}.csv"
	command = "java -cp moa.jar -javaagent:sizeofag.jar moa.DoTask \"EvaluatePrequentialActive -l #{classifier} -s #{generator} -i #{chunks} -b #{budget} -r #{threshold} -c #{chunkSize} -t #{timeCut}\" > results/#{outputFilename}"
	puts "# [#{experimentNumber}/#{experimentsCount}][#{(100*experimentNumber/experimentsCount).round}%]".red
	puts "# Testing #{classifierName} on #{generatorName}".yellow
	puts "# #{chunks} chunks #{chunkSize} instances each, on #{threshold} threshold and #{budget} budget".green

	puts "#{format("%.3f", experimentNumber.to_f / experimentsCount.to_f)}"
	open("http://156.17.43.89:8888/moaStatus/#{format("%.3f", experimentNumber.to_f / experimentsCount.to_f)}").read

	system(command)
end
end
end
end
end
end
