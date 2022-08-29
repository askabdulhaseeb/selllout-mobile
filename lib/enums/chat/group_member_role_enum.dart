enum GroupMemberRoleEnum { admin, member }

class GroupMemberRoleEnumConvertor {
 static String toJson(GroupMemberRoleEnum role) {
    if (role == GroupMemberRoleEnum.admin) {
      return 'admin';
    } else {
      return 'member';
    }
  }

static  GroupMemberRoleEnum fromMap(String role){
if (role == 'admin') {
      return GroupMemberRoleEnum.admin;
    } else {
      return GroupMemberRoleEnum.member;
    }
  }
}