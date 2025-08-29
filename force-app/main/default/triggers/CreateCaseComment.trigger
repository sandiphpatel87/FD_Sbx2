trigger CreateCaseComment on FeedItem (after insert)
{
    // Collect Case IDs from the Chatter posts
    Set<Id> caseIds = new Set<Id>();
    List<CaseComment> caseCommentsToInsert = new List<CaseComment>();
    
    // Collect the Chatter post IDs and Case IDs
    Map<Id, FeedItem> chatterPosts = new Map<Id, FeedItem>();
    for (FeedItem post : Trigger.new)
    {
        if (post.ParentId.getSObjectType() == Case.sObjectType) 
        {
            chatterPosts.put(post.Id, post);
        }
    }
    // Create Case Comments using Chatter post's body
    for (Id caseId : chatterPosts.keyset()) 
    {
        if (chatterPosts.containsKey(caseId)) 
        {
            FeedItem chatterPost = chatterPosts.get(caseId);
            If(chatterPost.Body!= null)
            {
                String regExp = '<style>[^<]*<\\/style>|<\\/?\\w*\\b[^>]*>'; 
                Pattern tagPattern = Pattern.compile(regExp); 
                String plainTextBody = tagPattern.matcher(chatterPost.Body).replaceAll('');
                system.debug('plainTextBody --'+plainTextBody);
                CaseComment caseComment = new CaseComment();
                caseComment.ParentId = chatterPost.ParentId;
                caseComment.CommentBody = plainTextBody;
                caseCommentsToInsert.add(caseComment);
            }
        }
    }
    
    // Insert Case Comments
    if (caseCommentsToInsert.Size() > 0) 
    {
        insert caseCommentsToInsert;
    }
}