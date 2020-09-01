public with sharing class CsvReader {
   
    /**
     * Comma String as defined by IETF RFC 4180.
     */
    public static final String ParserCOMMA = String.fromCharArray(new List<Integer> { 44 });
 
    /**
     * Carriage return String as defined by Salesforce documentation.
     *
     * Force.com IDE Library >
     * Apex Developer's Guide >
     * Language Constructs >
     * Data Types >
     * Primitive Data Types
     */
    public static final String ParserCR = '\r';
     
    /**
     * Double-quote String as defined by Salesforce documentation.
     *
     * Force.com IDE Library >
     * Apex Developer's Guide >
     * Language Constructs >
     * Data Types >
     * Primitive Data Types
     */
    public static final String ParserDQUOTE = '\"';
     
    /**
     * Line feed String as defined by Salesforce documentation.
     *
     * Force.com IDE Library >
     * Apex Developer's Guide >
     * Language Constructs >
     * Data Types >
     * Primitive Data Types
     */
    public static final String ParserLF = '\n';
     
    /**
     * Carriage return String followed by a line feed String.
     */
    public static final String ParserCRLF = ParserCR + ParserLF;
     
    /**
     * Line feed String followed by a carriage return String.
     */
    public static final String ParserLFCR = ParserLF + ParserCR;
   
    /**
     * Escaped double-quotes per IETF RFC 4180.
     */
    public static final String ParserDQUOTEDQUOTE = ParserDQUOTE + ParserDQUOTE;
 
 /**
     * Returns a List containing Lists of Strings that represents
     * the values contained in an IETF RFC 4180-compliant CSV file.
     *
     * Each element in the outer list represents a row in the CSV file.
     * Each element in the inner list is the value in the field specified
     * by the row-column combination.
     *
     * @param  file the CSV file to read
     * @return      the List<List<String>> containing values read from the
     *              CSV file
     */
    public static List<List<String>> readIETFRFC4180CSVFile(Blob file) {
        String fileString = file.toString();
         
        if (!fileString.endsWith(ParserCRLF)) {
          fileString = fileString + ParserCRLF;
        }
         
        List<List<String>> fileValues = new List<List<String>>();
        List<String> rowValues = new List<String>();
        CSVValue csvValue = new CSVValue();
         
        Boolean eod = false;  // Whether end of CSV data is reached
        while (!eod) {
          System.debug(fileString);
           
            csvValue = readIETFRFC4180CSVValue(fileString);
             
            rowValues.add(csvValue.value);
             
            if (csvValue.delimiter == ParserCRLF) {
              fileValues.add(rowValues);
               
              System.debug(rowValues);
               
              if (fileValues.size() > 0) {
                System.assertEquals(fileValues.get(0).size(),
                      rowValues.size());
              }
               
              rowValues = new List<String>();
            }
             
            if (csvValue.biteSize() == fileString.length()) {
              eod = true;
            }
            else {
              fileString = fileString.substring(csvValue.biteSize());
            }
        }
         
        return fileValues;
    }
     
    /**
     * Returns the first String value read from a String representation of
     * data contained in an IETF RFC 4180-compliant CSV file.
     *
     * The data is assumed to be terminated with a CRLF.
     *
     * @param  data the textual CSV data in one long string
     * @return      the first CSV value read from <code>data</code>.
     *              null is returned if no value is discerned.
     */
    public static CSVValue readIETFRFC4180CSVValue(String data) {
        System.assert(data.endsWith(ParserCRLF));
         
        CSVValue csvValue = new CSVValue();
         
        if (data.startsWith(ParserDQUOTE)) {
          csvValue.enclosed = true;
           
            Integer searchIndex = 1;      // starting index to search
            Integer dquoteIndex = -1;     // index of DQUOTE
            Integer dquotesIndex = -1;    // index of DQUOTEDQUOTE
                             
            Boolean closerFound = false;
             
            while (!closerFound) {
                dquoteIndex = data.indexOf(ParserDQUOTE, searchIndex);
                 
                dquotesIndex = data.indexOf(ParserDQUOTEDQUOTE,
                        searchIndex);
                 
                System.assert(dquoteIndex != -1);
                 
                if (dquoteIndex == dquotesIndex) {
                    searchIndex = dquotesIndex
                            + ParserDQUOTEDQUOTE.length();
                }
                else {
                    closerFound = true;
                }
            }
             
            csvValue.value = data.substring(
                    ParserDQUOTE.length(), dquoteIndex)
                            .replaceAll(ParserDQUOTEDQUOTE, ParserDQUOTE);
             
            Integer commaIndex = data.indexOf(ParserCOMMA, dquoteIndex);
            Integer crlfIndex = data.indexOf(ParserCRLF, dquoteIndex);
             
            if (commaIndex != -1 && commaIndex < crlfIndex) {
                csvValue.delimiter = ParserCOMMA;
            }
            else {
                csvValue.delimiter = ParserCRLF;
            }
        }
        else {
          csvValue.enclosed = false;
           
            Integer commaIndex = data.indexOf(ParserCOMMA);
            Integer crlfIndex = data.indexOf(ParserCRLF);
             
            if (commaIndex != -1 && commaIndex < crlfIndex) {
                csvValue.value = data.substring(0, commaIndex);
                csvValue.delimiter = ParserCOMMA;
            }
            else {
                csvValue.value = data.substring(0, crlfIndex);
                csvValue.delimiter = ParserCRLF;
            }
        }
         
        System.debug('Returning: ' + csvValue);
         
        return csvValue;
    }
     
    /**
     * CSVValue is a class structure containing information about a CSV
     * value that was read from a CSV file, including such information as
     * whether the value was encapsulated in double-quotes.
     */
    private class CSVValue {
        /**
         * The field value that was read from the CSV file.
         */
        public String value;
         
        /**
         * Whether the value was surrounded by double-quotes.
         */
        public Boolean enclosed;
         
        /**
         * The comma or CRLF delimiter that identified the end of the CSV value.
         */
        public String delimiter;
         
        /**
         * Default constructor, setting all members to null.
         */
        public CSVValue() {
            this(null, null, null);
        }
         
        /**
         * Constructor.
         *
         * @param value     the field value
         * @param enclosed  whether the value was surrounded by double-quotes
         * @param delimiter the delimiter that identified the end
         *                  of the CSV value
         */
        public CSVValue(String value, Boolean enclosed, String delimiter) {
            this.value = value;
            this.enclosed = enclosed;
            this.delimiter = delimiter;
        }
         
        /**
         * Returns the number of characters to remove from the data
         * String which produced the CSVValue in order to reach the next
         * value in the data String.
         */
        public Integer biteSize() {
          Integer biteSize = value
                 .replaceAll(ParserDQUOTE, ParserDQUOTEDQUOTE).length()
                         + delimiter.length();
           
          if (enclosed) {
            biteSize += ParserDQUOTE.length() * 2;
          }
           
          System.debug('biteSize: ' + biteSize);
           
          return biteSize;
        }
         
        /**
         * Returns whether a CSVValue has the same <code>value</code> and
         * <code>enclosed</code> as another CSVValue.
         */
        public Boolean equals(CSVValue compCSVValue) {
            return this.value.equals(compCSVValue.value)
                    && this.enclosed == compCSVValue.enclosed
                            && this.delimiter == compCSVValue.delimiter;
        }
         
        /**
         * Asserts that two <code>CSVValue</code> instances have the same
         * <code>value</code> and <code>enclosed</code>.
         */
        public void assertEquals(CSVValue compCSVValue) {
            System.assertEquals(value, compCSVValue.value);
            System.assertEquals(enclosed, compCSVValue.enclosed);
            System.assertEquals(delimiter, compCSVValue.delimiter);
        }
    }
     
    /**
     * Test some use cases for reading IETF RFC 4180-compliant CSV values.
     */
    /* TODO: Move to a separate class
    public static testMethod void readIETFRFC4180CSVValueTest() {
        String data = null;  // Placeholder for data to use in testing.
         
        System.debug(data = ParserCRLF);
        new CSVValue('', false, ParserCRLF)
                .assertEquals(readIETFRFC4180CSVValue(data));
         
        System.debug(data = '""' + ParserCRLF);
        new CSVValue('', true, ParserCRLF)
                .assertEquals(readIETFRFC4180CSVValue(data));
         
        System.debug(data = '"",asdf' + ParserCRLF);
        new CSVValue('', true, ParserCOMMA)
                .assertEquals(readIETFRFC4180CSVValue(data));
         
        System.debug(data = ',asdf' + ParserCRLF);
        new CSVValue('', false, ParserCOMMA)
                .assertEquals(readIETFRFC4180CSVValue(data));
         
        System.debug(data = '"' + ParserCRLF + '",blah' + ParserCRLF);
        new CSVValue(ParserCRLF, true, ParserCOMMA)
                .assertEquals(readIETFRFC4180CSVValue(data));
         
        System.debug(data = '"""marty""","""chang"""' + ParserCRLF);
        new CSVValue('"marty"', true, ParserCOMMA)
                .assertEquals(readIETFRFC4180CSVValue(data));
         
        System.debug(data = '"com""pli""cate' + ParserCRLF + 'd"'
                + ParserCRLF);
        new CSVValue('com"pli"cate' + ParserCRLF + 'd', true, ParserCRLF)
                .assertEquals(readIETFRFC4180CSVValue(data));
         
        System.debug(data = 'asdf' + ParserCRLF);
        new CSVValue('asdf', false, ParserCRLF)
                .assertEquals(readIETFRFC4180CSVValue(data));
    }
    */
 
}