public class NCMCommunityUsersReportController {
  @AuraEnabled
    public static List <User> fetchUsers(String searchNCM20Group) {
        
        String query;
       
        if(searchNCM20Group == null  || searchNCM20Group == '' )
        {
            query = ' select Id,Name,Email,Username,Contact.Account.Name,Contact.Account.Id , Contact.Account.Sub_Parent__r.Name,FirstName, LastName ,Profile.Name,CreatedDate, LastModifiedDate  from User  Where   Profile.Name = \'Foundation Partner Community\' order by CreatedDate Desc'; 
        }
        
        else if(searchNCM20Group != null)
        {
            query = 'select Id,Name,Email,Username,Contact.Account.Name,Contact.Account.Id , Contact.Account.Sub_Parent__r.Name,FirstName, LastName ,Profile.Name,CreatedDate, LastModifiedDate  from User  Where   Profile.Name = \'Foundation Partner Community\' AND Contact.Account.Sub_Parent__r.Name like '+ '\'%'+ searchNCM20Group + '%\' order by CreatedDate Desc'; 
        }
        
        List <User> userList = Database.query(query);
        return userList;
    }

}