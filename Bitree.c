#include "BiTree.h"
#include <malloc.h>
#include <stdlib.h>

BiTree InitBiTree(BiTNode *root)
{
	BiTree tree=root;
	return root;
}

BiTNode *MakeNode(Item item,BiTNode *lichild,BiTNode *rchild)
{
	BiTNode * pnode=(BiTNode *)malloc(sizeof(BiTNode));
	if(pnode)
	{
		pnode->data=item;
		pnode->lichild=lichild;
		pnode->rchild=rchild;
	}
	return pnode;
}

/*返回树的深度*/
int GetDeepth(BiTree tree)
{
	int cd,ld,rd;
	cd=ld=rd=0;
	if(tree)
	{
		ld=GetDeepth(tree->lichild);
		rd=GetDeepth(tree->rchild);
		cd=(ld>rd?ld:rd);
		return cd+1;
	}
}