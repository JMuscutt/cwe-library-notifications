# Checks that URLs stored in the Database actually work
class UrlValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        begin
            response = Net::HTTP.get_response(URI.parse(value))
        rescue
            record.errors[attribute] << 'Could not parse or fetch the URI given'
            return false
        end
        if response.body.include? 'not found'
            record.errors[attribute] << 'Image not found'
        else
            unless ['200', '301', '302'].include? response.code
                record.errors[attribute] << 'Server responded not ok'
            end
        end
    end
end
