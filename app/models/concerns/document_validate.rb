module DocumentValidate
  extend ActiveSupport::Concern

  class_methods do
    def document_validate(*attrs)
      return if attrs.size.zero?

      attrs.each do |attribute|
        validate do
          validate_document(attribute)
        end
      end
    end
  end

  private

  def validate_document(attribute)
    document_number = send(attribute)
    return errors.add(attribute, :document_number_length) unless valid_document_length?(document_number)

    if document_number.length == 14
      cpf_validation(attribute)
    else
      cnpj_validation(attribute)
    end
  end

  def valid_document_length?(document_number)
    return true if document_number.blank?
    return true if [ 14, 18 ].include?(document_number.length)

    false
  end

  def cpf_validation(attribute)
    invalid_cpfs = %w[
      12345678909 11111111111 22222222222 33333333333 44444444444 55555555555
      66666666666 77777777777 88888888888 99999999999 00000000000
    ]
    document_number = send(attribute)
    digits = document_number.scan(/\d/)

    if digits.length == 11 && !invalid_cpfs.include?(digits.join)
      digits = digits.map(&:to_i)
      sum1 = (10 * digits[0]) + (9 * digits[1]) + (8 * digits[2]) + (7 * digits[3]) + (6 * digits[4]) +
        (5 * digits[5]) + (4 * digits[6]) + (3 * digits[7]) + (2 * digits[8])

      sum1 = sum1 - (11 * (sum1 / 11))
      check_digit1 = (sum1 == 0 || sum1 == 1) ? 0 : 11 - sum1

      if check_digit1 == digits[9]
        sum2 = (digits[0] * 11) + (digits[1] * 10) + (digits[2] * 9) + (digits[3] * 8) + (digits[4] * 7) +
          (digits[5] * 6) + (digits[6] * 5) + (digits[7] * 4) + (digits[8] * 3) + (digits[9] * 2)

        sum2 = sum2 - (11 * (sum2 / 11))
        check_digit2 = (sum2 == 0 || sum2 == 1) ? 0 : 11 - sum2

        return true if check_digit2 == digits[10]
      end
    end

    errors.add(attribute, :invalid)
  end

  def cnpj_validation(attribute)
    invalid_cnpjs = %w[
      11111111111111 22222222222222 33333333333333 44444444444444 55555555555555
      66666666666666 77777777777777 88888888888888 99999999999999 00000000000000
    ]
    document_number = send(attribute)
    digits = document_number.scan(/\d/)

    if digits.length == 14 && !invalid_cnpjs.include?(digits.join)
      digits = digits.map(&:to_i)
      sum1 = digits[0]*5 + digits[1]*4 + digits[2]*3 + digits[3]*2 + digits[4]*9 + digits[5]*8 + digits[6]*7 +
        digits[7]*6 + digits[8]*5 + digits[9]*4 + digits[10]*3 + digits[11]*2

      sum1 = sum1 - (11 * (sum1 / 11))
      check_digit1 = (sum1 == 0 || sum1 == 1) ? 0 : 11 - sum1

      if check_digit1 == digits[12]
        sum2 = digits[0]*6 + digits[1]*5 + digits[2]*4 + digits[3]*3 + digits[4]*2 + digits[5]*9 + digits[6]*8 +
          digits[7]*7 + digits[8]*6 + digits[9]*5 + digits[10]*4 + digits[11]*3 + digits[12]*2

        sum2 = sum2 - (11 * (sum2 / 11))
        check_digit2 = (sum2 == 0 || sum2 == 1) ? 0 : 11 - sum2

        return true if check_digit2 == digits[13]
      end
    end

    errors.add(attribute, :invalid)
  end
end
