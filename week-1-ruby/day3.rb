#Do:
# 1. Modify the CSV application to support an each method to return a CsvRow
# object. Use method_missing on that CsvRow to return the value for the column
# for a given heading.

module ActsAsCsv

    def self.included(base)
        base.extend ClassMethods
    end

    module ClassMethods
        def acts_as_csv
            include InstanceMethods
        end
    end

    module InstanceMethods

        attr_accessor :headers, :csv_rows

        def read
            file = File.new(self.class.to_s.downcase + '.txt')
            @headers = file.gets.chomp.split(', ')

            file.each do |row|
                csv_contents = row.chomp.split(', ')
                @csv_rows << CsvRow.new(@headers, csv_contents)
            end
        end

        def initialize
            @csv_rows = []
            read
        end

        def each &block
            @csv_rows.each &block
        end

    end

    class CsvRow
        attr_accessor :header_row, :content_row

        def initialize(header_row, content_row)
            @header_row = header_row
            @content_row = content_row
        end

        def method_missing name, *args
            content_index = @header_row.index(name.to_s)
            return @content_row[content_index]
        end
    end
end

class RubyCsv 
    include ActsAsCsv
    acts_as_csv
end

csv = RubyCsv.new
csv.each {|row| puts row.one}
