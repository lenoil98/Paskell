module Intermediate where 

import Grammar (OP, Type, Ident, IdentList, VarDecl, TypeDecl, ToDownTo) 

data Program = Program Ident Block Type deriving (Eq)
data Block = Block [Decl] Statement Type deriving (Eq)

data Decl = DeclVar [VarDecl] Type
    | DeclType [TypeDecl]  Type
    | DeclConst [ConstDecl]  Type
    | DeclProc Ident [(Ident,Type,Bool)] Block Type
    | DeclFunc Ident [(Ident,Type,Bool)] Type Block Type
    deriving (Eq)
data ConstDecl = ConstDecl Type deriving (Show, Eq) -- todo 

data Statement = StatementSeq [Statement] Type
    | Assignment Designator Expr Type
    | ProcCall Ident ExprList Type
    | StatementIf Expr Statement (Maybe Statement) Type
    | StatementCase Type
    | StatementWhile Expr Statement Type
    | StatementRepeat Statement Expr Type
    | StatementFor Ident Expr ToDownTo Expr Statement Type
    | StatementNew Ident Type
    | StatementDispose Ident Type
    | StatementEmpty
    | StatmentRead DesigList Type
    | StatementReadLn DesigList Type
    | StatementWrite ExprList Type
    | StatementWriteLn ExprList Type
    deriving (Eq) 

data Designator = Designator Ident [DesigProp] Type deriving (Eq)
data DesigList = DesigList [Designator] Type deriving (Show, Eq)
data DesigProp = DesigPropIdent Ident  Type
    | DesigPropExprList ExprList  Type
    | DesigPropPtr  Type
    deriving (Show, Eq)

type ExprList = [Expr]
data Expr = Relation Expr OP Expr Type
    | Unary OP Expr Type
    | Mult Expr OP Expr Type
    | Add Expr OP Expr Type
    | FactorInt Int  Type
    | FactorReal Double  Type
    | FactorStr String  Type
    | FactorTrue  Type
    | FactorFalse  Type
    | FactorNil  Type
    | FactorDesig Designator  Type
    | FactorNot Expr Type
    | FuncCall Ident ExprList Type
    deriving (Eq)

getType :: Expr -> Type
getType (Relation _ _ _ t) = t
getType (Unary _ _ t) = t
getType (Mult _ _ _ t) = t
getType (Add  _ _ _ t) = t
getType (FactorInt _  t) = t
getType (FactorReal _  t) = t
getType (FactorStr _  t) = t
getType (FactorTrue  t) = t
getType (FactorFalse  t) = t
getType (FactorNil  t) = t
getType (FactorDesig _  t) = t
getType (FactorNot _ t) = t
getType (FuncCall _ _ t) = t


instance Show Program where
    show (Program x b _) = "Program "++  x ++ "\n" ++ (show b)++"\nend."

instance Show Block where
    show (Block ds s _) = "{\n"++ (show ds)++ "\n" ++ (show s)++"\n}"

instance Show Decl where
    show (DeclVar xs _) = "Var " ++ (show xs)
    show (DeclType xs _) = "Type " ++ (show xs)
    show (DeclConst xs _) = "Const " ++ (show xs)
    show (DeclProc x xs b _) = "Proc " ++  x ++ " "++ show((map (\(a',b',_) -> (show a')++":"++(show b')) xs)) ++ (show b) 
    show (DeclFunc x xs t b _) = "Func " ++ x ++ ":" ++(show t) ++" "++ show((map (\(a',b',_) -> a'++":"++(show b')) xs)) ++ (show b) 

instance Show Designator where
    show (Designator x _ t) = x ++ ":" ++ (show t)

instance Show Statement where
    show (Assignment x ex t) = (show x) ++ " := " ++ (show ex)
    show (StatementEmpty) = ""
    show (StatementSeq xs _) = if length xs == 0 then "" else show xs
    show (StatementIf ex s ms _) = "if "++ (show ex) ++" "++(show s) ++ (
        case ms of Nothing -> ""
                   Just s2 -> " " ++ (show s2))
    show _ = "??"

instance Show Expr where
    show (Relation ex1 op ex2 t) =  "("++(show ex1) ++ (show op) ++ (show ex2) ++ "):" ++ (show t) 
    show (Unary op ex t) = "(" ++(show op) ++ (show ex) ++ "):" ++ (show t) 
    show (Mult ex1 op ex2 t) = "("++(show ex1) ++ (show op) ++ (show ex2) ++ "):" ++ (show t) 
    show (Add ex1 op ex2 t) = "("++(show ex1) ++ (show op) ++ (show ex2) ++ "):" ++ (show t) 
    show (FactorInt x  t) = (show x) ++ ":" ++ (show t) 
    show (FactorReal x  t) = (show x) ++ ":" ++ (show t) 
    show (FactorStr x  t) = (show x) ++ ":" ++ (show t) 
    show (FactorTrue  t) = "True" ++ ":" ++ (show t) 
    show (FactorFalse  t) = "False" ++ ":" ++ (show t) 
    show (FactorNil  t) = "Nil" ++ ":" ++ (show t) 
    show (FactorDesig x t) = (show x) ++ ":" ++ (show t) 
    show (FactorNot ex t) = undefined
    show (FuncCall x exs t) = (show x) ++ "("++ (if length exs == 0 then "" else show exs) ++"):"++(show t)