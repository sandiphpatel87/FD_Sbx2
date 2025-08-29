public class CampaignTabLabelMap {
    public static Map<String,String> setMap(){
        Map<String,String> nameMap = new Map<String,String>();
        nameMap.put('Dealership Name', 'Standard,New,4');
        nameMap.put('Make Geo & Make Near Me', 'Standard,New,4');
        nameMap.put('Model Geo & Model Lease', 'Standard,New,4');
        nameMap.put('Make Purchase Intent', 'Standard,New,4');
        nameMap.put('Make Model Purchase Intent', 'Standard,New,4');
        nameMap.put('Used Year Make Model', 'Standard,Used,4');
        nameMap.put('Used Make Model', 'Standard,Used,4');
        nameMap.put('*Used Make', 'Standard,Used,4');
        nameMap.put('Certified Make Model', 'Standard,Used,4');
        nameMap.put('Certified Make', 'Standard,Used,4');
        nameMap.put('Service - Dealer Name', 'Standard,Service,4');
        nameMap.put('Service - Make', 'Standard,Service,4');
        nameMap.put('Service - Offers', 'Standard,Service,4');
        
        nameMap.put('Make Model Upper Funnel', 'Manual,New,8');
        nameMap.put('Used Acquisition', 'Manual,Used,8');
        nameMap.put('No Credit / Low Credit', 'Manual,Used,16');
        nameMap.put('Used Dealer Name*', 'Manual,Used,16');
        nameMap.put('Service - Model', 'Manual,Service,16');
        
        nameMap.put('Future Model', 'Supplemental,New,24');
        nameMap.put('Specfiic Model MMPI', 'Supplemental,New,16');
        nameMap.put('Conquest MMPI', 'Supplemental,New,24');
        nameMap.put('Out of Stock MMPI **NON APOLLO**', 'Supplemental,New,32');
        nameMap.put('Spanish', 'Supplemental,New,40');
        nameMap.put('Hybrid/Electric Purchase Intent', 'Supplemental,New,24');
        nameMap.put('Dealer Name Supplemental', 'Supplemental,New,16');
        nameMap.put('Lease Termination', 'Supplemental,New,24');
        
        nameMap.put('VLA (Vehicle Listing Ads)', 'Supplemental,Used,16');
        nameMap.put('Cars for Sale (GMB)', 'Supplemental,Used,8');
        nameMap.put('Spanish Used', 'Supplemental,Used,32');
        nameMap.put('On/Off Brand Campaigns', 'Supplemental,Used,32');
        nameMap.put('Used Specific Purchase Intent', 'Supplemental,Used,24');
        nameMap.put('Used Brand Conquest', 'Supplemental,Used,24');
        nameMap.put('**NON APOLLO** Static Used Year Make Model', 'Supplemental,Used,32');
        
        nameMap.put('Collision', 'Supplemental,Service,24');
        nameMap.put('Parts', 'Supplemental,Service,24');
        nameMap.put('CONQUEST Service', 'Supplemental,Service,24');
        nameMap.put('NON BRAND Service', 'Supplemental,Service,24');
        nameMap.put('Service -  Supplemental', 'Supplemental,Service,24');
        nameMap.put('Static Service - Conquest', 'Supplemental,Service,24');
        nameMap.put('Static Service - Non-branded', 'Supplemental,Service,24');
        
        nameMap.put('Dealership Why Buy Campaign', 'Supplemental,Video,16');
        nameMap.put('Future Model Video Campaign', 'Supplemental,Video,16');
        nameMap.put('Service Custom Video Campaign', 'Supplemental,Video,16');
        nameMap.put('Esp Dealership Why Buy Campaign', 'Supplemental,Video,16');
        nameMap.put('Used Acquisition Video', 'Supplemental,Video,16');
        nameMap.put('Dealer Why Buy Display Remarketing', 'Supplemental,Display,16');
        nameMap.put('**No Payment Version of Standard Campaigns**', 'Supplemental,Facebook,16');
        nameMap.put('Facebook Dealer Custom Creative', 'Supplemental,Facebook,16');
        
        
        
        nameMap.put('Google/Bing', 'Upsell,New,16');
        nameMap.put('Facebook AIA', 'Upsell,New,24');
        nameMap.put('Video', 'Upsell,New,24');
        nameMap.put('Display', 'Upsell,New,16');
        return nameMap;
    }
}