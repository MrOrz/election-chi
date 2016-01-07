require 'json'
require "fileutils"

OUTPUT_DIR = 'chi'

def calc_total_term_frequencies(term_frequencies_for_category)
  term_frequencies_global = {}
  term_frequencies_for_category.each do |term_frequencies_in_category| # each document
    term_frequencies_in_category.each do |term, freq| # each term
      term_frequencies_global[term] ||= 0
      term_frequencies_global[term] += freq
    end # each term
  end # each document
  term_frequencies_global
end

def calculate_chi_square(file_names)
  # puts file_names.join(' / ')
  # puts "-------"
  term_frequencies_for_category = file_names.map{|f| JSON.parse(File.read(f))}
  term_frequencies_global = calc_total_term_frequencies(term_frequencies_for_category)
  term_counts_for_category = term_frequencies_for_category.map{|term_frequencies_in_category| term_frequencies_in_category.values.reduce{|sum, tf| sum+tf}}
  term_counts_total = term_counts_for_category.reduce{|sum, count| sum+count}

  term_frequencies_for_category.each_with_index do |term_frequencies_in_category, idx|
    term_count_in_cat = term_counts_for_category[idx] # total count of all terms in this category, i.e. #(t,c) + #(!t,c)
    term_count_not_in_cat = term_counts_total - term_count_in_cat # total count of all terms not in this category, i.e. #(t,!c) + #(!t, !c)

    statistics = []
    term_frequencies_in_category.each do |term, freq|
      # term_frequencies_global[term] equals #(t, c) + #(t, !c)

      a = freq  # #(t,c)
      b = term_frequencies_global[term] - a # #(t, !c)
      c = term_count_in_cat - a #(!t, c)
      d = term_count_not_in_cat - b #(!t, !c)
      n = a + b + c + d

      chi_square = n * (a.to_f*d-c*b)**2 / ((a+c)*(b+d)*(a+b)*(c+d))
      statistics << [term, chi_square]
    end
    statistics.sort!{|x, y| y[1] <=> x[1]} # sort using chi_square, descendent

    output_file_name = file_names[idx].gsub /^sum/, OUTPUT_DIR
    FileUtils::mkdir_p File.dirname(output_file_name)

    File.open(output_file_name, 'w'){|f| f.write JSON.pretty_generate(statistics)}
    puts "Written to #{output_file_name}"
  end


end


def main
  current_election_area = ''
  file_names = []
  Dir['sum/*/第*選舉區_*.json'].each do |file_name|
    election_area = file_name.match(/(.+)_/)[1]
    if election_area != current_election_area && file_name.size > 0
      calculate_chi_square(file_names)
      file_names = [file_name]
      current_election_area = election_area
    else
      file_names << file_name
    end
  end

  Dir['sum/*原住民/*.json'].each do |file_name|
    election_area = file_name.match(/(.+)\//)[1] # 「平地原住民」 or 「山地原住民」
    if election_area != current_election_area && file_name.size > 0
      calculate_chi_square(file_names)
      file_names = [file_name]
      current_election_area = election_area
    else
      file_names << file_name
    end
  end

  calculate_chi_square(file_names) if file_names.size > 0
end

main