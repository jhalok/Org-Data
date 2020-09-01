public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    @future( callout = true )
    public static void runWarehouseEquipmentSync() {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HTTPResponse response = new HTTPResponse();
        
        request.setEndpoint( WAREHOUSE_URL );
        request.setMethod( 'GET' );
        request.setHeader( 'Content-Type', 'text-xml' );
        response = http.send( request );
        
        List<WarehouseEquipment> warehouseEquipmentList = new WarehouseEquipment().parse( response.getBody() );
        List<Product2> productsToUpsert = new List<Product2>();
        
        // Update Salesforce Records
        for ( WarehouseEquipment whrEquip : warehouseEquipmentList ) {
            Product2 newProduct = new Product2( Warehouse_SKU__c  = whrEquip.id );
            newProduct.Replacement_Part__c = true;
            newProduct.Cost__c = whrEquip.cost;
            newProduct.Current_Inventory__c = whrEquip.quantity;
            newProduct.Lifespan_Months__c = whrEquip.lifespan;
            newProduct.Maintenance_Cycle__c = whrEquip.maintenanceperiod;
            newProduct.Name = whrEquip.name; 
            productsToUpsert.add( newProduct );
        }

        upsert productsToUpsert;
    }
    
    public class WarehouseEquipment {
        public String name;
        public Boolean replacement;
        public Integer quantity;
        public Integer maintenanceperiod;
        public Integer lifespan;
        public Integer cost;
        public String sku;
        public String id;
        
        public List<WarehouseEquipment> parse( String json ) {
            json.replace( '"id":', '"_id ":' );
            return ( List<WarehouseEquipment> ) System.JSON.deserialize( json, List<WarehouseEquipment>.class );
        }
    }

}