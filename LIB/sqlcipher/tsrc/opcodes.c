/* Automatically generated.  Do not edit */
/* See the mkopcodec.awk script for details. */
#if !defined(SQLITE_OMIT_EXPLAIN) || defined(VDBE_PROFILE) || defined(SQLITE_DEBUG)
#if defined(SQLITE_ENABLE_EXPLAIN_COMMENTS) || defined(SQLITE_DEBUG)
# define OpHelp(X) "\0" X
#else
# define OpHelp(X)
#endif
const char *sqlite3OpcodeName(int i){
 static const char *const azName[] = { "?",
     /*   1 */ "Function"         OpHelp("r[P3]=func(r[P2@P5])"),
     /*   2 */ "Savepoint"        OpHelp(""),
     /*   3 */ "AutoCommit"       OpHelp(""),
     /*   4 */ "Transaction"      OpHelp(""),
     /*   5 */ "SorterNext"       OpHelp(""),
     /*   6 */ "PrevIfOpen"       OpHelp(""),
     /*   7 */ "NextIfOpen"       OpHelp(""),
     /*   8 */ "Prev"             OpHelp(""),
     /*   9 */ "Next"             OpHelp(""),
     /*  10 */ "AggStep"          OpHelp("accum=r[P3] step(r[P2@P5])"),
     /*  11 */ "Checkpoint"       OpHelp(""),
     /*  12 */ "JournalMode"      OpHelp(""),
     /*  13 */ "Vacuum"           OpHelp(""),
     /*  14 */ "VFilter"          OpHelp("iplan=r[P3] zplan='P4'"),
     /*  15 */ "VUpdate"          OpHelp("data=r[P3@P2]"),
     /*  16 */ "Goto"             OpHelp(""),
     /*  17 */ "Gosub"            OpHelp(""),
     /*  18 */ "Return"           OpHelp(""),
     /*  19 */ "Not"              OpHelp("r[P2]= !r[P1]"),
     /*  20 */ "InitCoroutine"    OpHelp(""),
     /*  21 */ "EndCoroutine"     OpHelp(""),
     /*  22 */ "Yield"            OpHelp(""),
     /*  23 */ "HaltIfNull"       OpHelp("if r[P3]=null halt"),
     /*  24 */ "Halt"             OpHelp(""),
     /*  25 */ "Integer"          OpHelp("r[P2]=P1"),
     /*  26 */ "Int64"            OpHelp("r[P2]=P4"),
     /*  27 */ "String"           OpHelp("r[P2]='P4' (len=P1)"),
     /*  28 */ "Null"             OpHelp("r[P2..P3]=NULL"),
     /*  29 */ "SoftNull"         OpHelp("r[P1]=NULL"),
     /*  30 */ "Blob"             OpHelp("r[P2]=P4 (len=P1)"),
     /*  31 */ "Variable"         OpHelp("r[P2]=parameter(P1,P4)"),
     /*  32 */ "Move"             OpHelp("r[P2@P3]=r[P1@P3]"),
     /*  33 */ "Copy"             OpHelp("r[P2@P3+1]=r[P1@P3+1]"),
     /*  34 */ "SCopy"            OpHelp("r[P2]=r[P1]"),
     /*  35 */ "ResultRow"        OpHelp("output=r[P1@P2]"),
     /*  36 */ "CollSeq"          OpHelp(""),
     /*  37 */ "AddImm"           OpHelp("r[P1]=r[P1]+P2"),
     /*  38 */ "MustBeInt"        OpHelp(""),
     /*  39 */ "RealAffinity"     OpHelp(""),
     /*  40 */ "Cast"             OpHelp("affinity(r[P1])"),
     /*  41 */ "Permutation"      OpHelp(""),
     /*  42 */ "Compare"          OpHelp("r[P1@P3] <-> r[P2@P3]"),
     /*  43 */ "Jump"             OpHelp(""),
     /*  44 */ "Once"             OpHelp(""),
     /*  45 */ "If"               OpHelp(""),
     /*  46 */ "IfNot"            OpHelp(""),
     /*  47 */ "Column"           OpHelp("r[P3]=PX"),
     /*  48 */ "Affinity"         OpHelp("affinity(r[P1@P2])"),
     /*  49 */ "MakeRecord"       OpHelp("r[P3]=mkrec(r[P1@P2])"),
     /*  50 */ "Count"            OpHelp("r[P2]=count()"),
     /*  51 */ "ReadCookie"       OpHelp(""),
     /*  52 */ "SetCookie"        OpHelp(""),
     /*  53 */ "ReopenIdx"        OpHelp("root=P2 iDb=P3"),
     /*  54 */ "OpenRead"         OpHelp("root=P2 iDb=P3"),
     /*  55 */ "OpenWrite"        OpHelp("root=P2 iDb=P3"),
     /*  56 */ "OpenAutoindex"    OpHelp("nColumn=P2"),
     /*  57 */ "OpenEphemeral"    OpHelp("nColumn=P2"),
     /*  58 */ "SorterOpen"       OpHelp(""),
     /*  59 */ "SequenceTest"     OpHelp("if( cursor[P1].ctr++ ) pc = P2"),
     /*  60 */ "OpenPseudo"       OpHelp("P3 columns in r[P2]"),
     /*  61 */ "Close"            OpHelp(""),
     /*  62 */ "SeekLT"           OpHelp("key=r[P3@P4]"),
     /*  63 */ "SeekLE"           OpHelp("key=r[P3@P4]"),
     /*  64 */ "SeekGE"           OpHelp("key=r[P3@P4]"),
     /*  65 */ "SeekGT"           OpHelp("key=r[P3@P4]"),
     /*  66 */ "Seek"             OpHelp("intkey=r[P2]"),
     /*  67 */ "NoConflict"       OpHelp("key=r[P3@P4]"),
     /*  68 */ "NotFound"         OpHelp("key=r[P3@P4]"),
     /*  69 */ "Found"            OpHelp("key=r[P3@P4]"),
     /*  70 */ "NotExists"        OpHelp("intkey=r[P3]"),
     /*  71 */ "Or"               OpHelp("r[P3]=(r[P1] || r[P2])"),
     /*  72 */ "And"              OpHelp("r[P3]=(r[P1] && r[P2])"),
     /*  73 */ "Sequence"         OpHelp("r[P2]=cursor[P1].ctr++"),
     /*  74 */ "NewRowid"         OpHelp("r[P2]=rowid"),
     /*  75 */ "Insert"           OpHelp("intkey=r[P3] data=r[P2]"),
     /*  76 */ "IsNull"           OpHelp("if r[P1]==NULL goto P2"),
     /*  77 */ "NotNull"          OpHelp("if r[P1]!=NULL goto P2"),
     /*  78 */ "Ne"               OpHelp("if r[P1]!=r[P3] goto P2"),
     /*  79 */ "Eq"               OpHelp("if r[P1]==r[P3] goto P2"),
     /*  80 */ "Gt"               OpHelp("if r[P1]>r[P3] goto P2"),
     /*  81 */ "Le"               OpHelp("if r[P1]<=r[P3] goto P2"),
     /*  82 */ "Lt"               OpHelp("if r[P1]<r[P3] goto P2"),
     /*  83 */ "Ge"               OpHelp("if r[P1]>=r[P3] goto P2"),
     /*  84 */ "InsertInt"        OpHelp("intkey=P3 data=r[P2]"),
     /*  85 */ "BitAnd"           OpHelp("r[P3]=r[P1]&r[P2]"),
     /*  86 */ "BitOr"            OpHelp("r[P3]=r[P1]|r[P2]"),
     /*  87 */ "ShiftLeft"        OpHelp("r[P3]=r[P2]<<r[P1]"),
     /*  88 */ "ShiftRight"       OpHelp("r[P3]=r[P2]>>r[P1]"),
     /*  89 */ "Add"              OpHelp("r[P3]=r[P1]+r[P2]"),
     /*  90 */ "Subtract"         OpHelp("r[P3]=r[P2]-r[P1]"),
     /*  91 */ "Multiply"         OpHelp("r[P3]=r[P1]*r[P2]"),
     /*  92 */ "Divide"           OpHelp("r[P3]=r[P2]/r[P1]"),
     /*  93 */ "Remainder"        OpHelp("r[P3]=r[P2]%r[P1]"),
     /*  94 */ "Concat"           OpHelp("r[P3]=r[P2]+r[P1]"),
     /*  95 */ "Delete"           OpHelp(""),
     /*  96 */ "BitNot"           OpHelp("r[P1]= ~r[P1]"),
     /*  97 */ "String8"          OpHelp("r[P2]='P4'"),
     /*  98 */ "ResetCount"       OpHelp(""),
     /*  99 */ "SorterCompare"    OpHelp("if key(P1)!=trim(r[P3],P4) goto P2"),
     /* 100 */ "SorterData"       OpHelp("r[P2]=data"),
     /* 101 */ "RowKey"           OpHelp("r[P2]=key"),
     /* 102 */ "RowData"          OpHelp("r[P2]=data"),
     /* 103 */ "Rowid"            OpHelp("r[P2]=rowid"),
     /* 104 */ "NullRow"          OpHelp(""),
     /* 105 */ "Last"             OpHelp(""),
     /* 106 */ "SorterSort"       OpHelp(""),
     /* 107 */ "Sort"             OpHelp(""),
     /* 108 */ "Rewind"           OpHelp(""),
     /* 109 */ "SorterInsert"     OpHelp(""),
     /* 110 */ "IdxInsert"        OpHelp("key=r[P2]"),
     /* 111 */ "IdxDelete"        OpHelp("key=r[P2@P3]"),
     /* 112 */ "IdxRowid"         OpHelp("r[P2]=rowid"),
     /* 113 */ "IdxLE"            OpHelp("key=r[P3@P4]"),
     /* 114 */ "IdxGT"            OpHelp("key=r[P3@P4]"),
     /* 115 */ "IdxLT"            OpHelp("key=r[P3@P4]"),
     /* 116 */ "IdxGE"            OpHelp("key=r[P3@P4]"),
     /* 117 */ "Destroy"          OpHelp(""),
     /* 118 */ "Clear"            OpHelp(""),
     /* 119 */ "ResetSorter"      OpHelp(""),
     /* 120 */ "CreateIndex"      OpHelp("r[P2]=root iDb=P1"),
     /* 121 */ "CreateTable"      OpHelp("r[P2]=root iDb=P1"),
     /* 122 */ "ParseSchema"      OpHelp(""),
     /* 123 */ "LoadAnalysis"     OpHelp(""),
     /* 124 */ "DropTable"        OpHelp(""),
     /* 125 */ "DropIndex"        OpHelp(""),
     /* 126 */ "DropTrigger"      OpHelp(""),
     /* 127 */ "IntegrityCk"      OpHelp(""),
     /* 128 */ "RowSetAdd"        OpHelp("rowset(P1)=r[P2]"),
     /* 129 */ "RowSetRead"       OpHelp("r[P3]=rowset(P1)"),
     /* 130 */ "RowSetTest"       OpHelp("if r[P3] in rowset(P1) goto P2"),
     /* 131 */ "Program"          OpHelp(""),
     /* 132 */ "Param"            OpHelp(""),
     /* 133 */ "Real"             OpHelp("r[P2]=P4"),
     /* 134 */ "FkCounter"        OpHelp("fkctr[P1]+=P2"),
     /* 135 */ "FkIfZero"         OpHelp("if fkctr[P1]==0 goto P2"),
     /* 136 */ "MemMax"           OpHelp("r[P1]=max(r[P1],r[P2])"),
     /* 137 */ "IfPos"            OpHelp("if r[P1]>0 goto P2"),
     /* 138 */ "IfNeg"            OpHelp("r[P1]+=P3, if r[P1]<0 goto P2"),
     /* 139 */ "IfNotZero"        OpHelp("if r[P1]!=0 then r[P1]+=P3, goto P2"),
     /* 140 */ "DecrJumpZero"     OpHelp("if (--r[P1])==0 goto P2"),
     /* 141 */ "JumpZeroIncr"     OpHelp("if (r[P1]++)==0 ) goto P2"),
     /* 142 */ "AggFinal"         OpHelp("accum=r[P1] N=P2"),
     /* 143 */ "IncrVacuum"       OpHelp(""),
     /* 144 */ "Expire"           OpHelp(""),
     /* 145 */ "TableLock"        OpHelp("iDb=P1 root=P2 write=P3"),
     /* 146 */ "VBegin"           OpHelp(""),
     /* 147 */ "VCreate"          OpHelp(""),
     /* 148 */ "VDestroy"         OpHelp(""),
     /* 149 */ "VOpen"            OpHelp(""),
     /* 150 */ "VColumn"          OpHelp("r[P3]=vcolumn(P2)"),
     /* 151 */ "VNext"            OpHelp(""),
     /* 152 */ "VRename"          OpHelp(""),
     /* 153 */ "Pagecount"        OpHelp(""),
     /* 154 */ "MaxPgcnt"         OpHelp(""),
     /* 155 */ "Init"             OpHelp("Start at P2"),
     /* 156 */ "Noop"             OpHelp(""),
     /* 157 */ "Explain"          OpHelp(""),
  };
  return azName[i];
}
#endif
