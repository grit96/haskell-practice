-- https://wiki.haskell.org/99_questions

import System.Random
import Data.List
import Data.Function

-- Problem 1
last' :: [a] -> a
last' [x] = x
last' (x:xs) = last' xs

-- Problem 2
butLast :: [a] -> a
butLast [x,_] = x
butLast (_:xs) = butLast xs

-- Problem 3
elementAt :: [a] -> Int -> a
elementAt (x:_) 1 = x
elementAt (_:xs) n = elementAt xs (n-1)

-- Problem 4
length' :: [a] -> Int
length' [] = 0
length' (_:xs) = 1 + length' xs

-- Problem 5
reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

-- Problem 6
isPalindrome :: Eq a => [a] -> Bool
isPalindrome xs = (reverse xs) == xs

-- Problem 7
data NestedList a = Elem a | List [NestedList a]
flatten :: NestedList a -> [a]
flatten (Elem x) = [x]
flatten (List []) = []
flatten (List (x:xs)) = flatten x ++ flatten (List xs)

-- Problem 8
compress :: Eq a => [a] -> [a]
compress (x:ys@(y:_))
  | x == y    = compress ys
  | otherwise = x : compress ys
compress ys = ys

-- Problem 9
pack :: Eq a => [a] -> [[a]]
pack [] = []
pack (x:xs) = (x:first) : pack rest
  where (first, rest) = span (==x) xs

-- Problem 10
rle :: Eq a => [a] -> [(Int, a)]
rle xs = map (\x -> (length x, head x)) (pack xs)

-- Problem 11
data ListItem a = Single a | Multiple Int a deriving (Show)
rle' :: Eq a => [a] -> [ListItem a]
rle' xs = map f (rle_direct xs)
  where f (1, x) = Single x
        f (n, x) = Multiple n x

-- Problem 12
rle_decode :: [ListItem a] -> [a]
rle_decode = concatMap f
  where f (Single x) = [x]
        f (Multiple n x) = replicate n x

-- Problem 13
rle_direct :: Eq a => [a] -> [(Int, a)]
rle_direct = foldr f []
  where f x [] = [(1, x)]
        f x (y@(a,b):ys)
          | x == b    = (1+a,b):ys
          | otherwise = (1,x):y:ys

-- Problem 14
duplicate :: [a] -> [a]
duplicate [] = []
duplicate (x:xs) = x : x : duplicate xs

-- Problem 15
replicate' :: [a] -> Int -> [a]
replicate' [] _ = []
replicate' (x:xs) n = [x | _ <- [1..n]] ++ replicate' xs n

-- Problem 16
drop' :: [a] -> Int -> [a]
drop' xs n = concat [f i | i <- [0..(length xs-1)]]
  where f i
          | ((i + 1) `mod` n) == 0 = []
          | otherwise              = [xs !! i]

-- Problem 17
split' :: [a] -> Int -> ([a], [a])
split' xs n = (take n xs, drop n xs)

-- Problem 18
slice :: [a] -> Int -> Int -> [a]
slice xs x y = f (split' xs (x-1)) (y-x+1)
  where f (_, ys) y = fst (split' ys y)

slice' :: [a] -> Int -> Int -> [a]
slice' xs x y = take (y-x+1) (drop (x-1) xs)

-- Problem 19
rotate :: [a] -> Int -> [a]
rotate xs 0 = xs
rotate xs n = drop l xs ++ take l xs
  where l = if n < 0 then length xs + n else n

-- Problem 20
remove :: Int -> [a] -> (a, [a])
remove n xs = (xs !! (n-1), take (n-1) xs ++ drop n xs)

-- Problem 21
insertAt :: a -> [a] -> Int -> [a]
insertAt x xs i = take (i-1) xs ++ [x] ++ drop (i-1) xs

-- Problem 22
range :: Int -> Int -> [Int]
range a b = [a..b]

-- Problem 23
rnd_select :: [a] -> Int -> IO [a]
rnd_select xs n = do
  gen <- getStdGen
  return $ take n [ xs !! x | x <- randomRs (0, (length xs) - 1) gen]

pick :: [a] -> IO a
pick xs = randomRIO (0, length xs - 1) >>= return . (xs !!)

-- Problem 24
diff_select :: Int -> Int -> IO [Int]
diff_select n m = rnd_select [1..m] n

-- Problem 25
rnd_permu :: [a] -> IO [a]
rnd_permu xs = rnd_select xs (length xs)

-- Problem 26
combinations :: Int -> [a] -> [[a]]
combinations 0 _ = [[]]
combinations n xs = [ xs !! i : x | i <- [0..(length xs)-1], x <- combinations (n-1) (drop (i+1) xs) ]

-- Problem 27
combination :: Int -> [a] -> [([a],[a])]
combination 0 xs = [([],xs)]
combination n [] = []
combination n (x:xs) = ts ++ ds
  where
    ts = [ (x:ys,zs) | (ys,zs) <- combination (n-1) xs ]
    ds = [ (ys,x:zs) | (ys,zs) <- combination n xs ]

group' :: [Int] -> [a] -> [[[a]]]
group' [] _ = [[]]
group' (n:ns) xs = [ g:gs | (g,rs) <- combination n xs, gs <- group' ns rs ]

-- Problem 28
lsort :: [[a]] -> [[a]]
lsort = sortBy (compare `on` length)

lfsort :: [[a]] -> [[a]]
lfsort = concat . lsort . groupBy ((==) `on` length) . lsort

-- Problem 31
isPrime :: Integral a => a -> Bool
isPrime n = null [ x | x <- [2..floor $ sqrt $ fromIntegral n], n `mod` x == 0 ]

-- Problem 32
gcd' :: Integral a => a -> a -> a
gcd' x 0 = abs x
gcd' x y = abs $ gcd' y $ x `rem` y

-- Problem 33
coprime :: Int -> Int -> Bool
coprime x y = gcd' x y == 1

-- Problem 34
totient :: Int -> Int
totient x = length $ filter (==True) [coprime n x | n <- [1..x]]

-- Problem 35
primeFactors :: Int -> [Int]
primeFactors x = f x 2
  where f 1 _ = []
        f x n
          | n * n > x      = [x]
          | x `mod` n == 0 = n : f (x `div` n) n
          | otherwise      = f x (n + 1)

-- Problem 36
primeFactorsM :: Int -> [(Int, Int)]
primeFactorsM x = map (\xs->(head xs, length xs)) . group . sort . primeFactors $ x

-- Problem 37
phi :: Int -> Int
phi x = foldr f 1 (primeFactorsM x)
  where f (a, b) n = n * (a - 1) * a ^ (b - 1)

-- Problem 39
primes :: Int -> Int -> [Int]
primes a b = [x | x <- [a..b], isPrime x]

-- Problem 40
goldbach :: Int -> (Int, Int)
goldbach n = head [(x, y) | x <- ps, y <- ps, x + y == n]
  where ps = primes 2 (n - 2)

-- Problem 41
goldbachList :: Int -> Int -> [(Int, Int)]
goldbachList a b = map goldbach $ filter even [a..b]

goldbachList' :: Int -> Int -> Int -> [(Int, Int)]
goldbachList' a b c = filter (\(x, y) -> x > c && y > c) (goldbachList a b)

-- Problem 46
not' :: Bool -> Bool
not' True = False
not' False = True

and' :: Bool -> Bool -> Bool
and' True True = True
and' _ _ = False

or' :: Bool -> Bool -> Bool
or' False False = False
or' _ _ = True

nand' :: Bool -> Bool -> Bool
nand' a b = not' $ and' a b

nor' :: Bool -> Bool -> Bool
nor' a b = not' $ or' a b

xor' :: Bool -> Bool -> Bool
xor' True False = True
xor' False True = True
xor' _ _ = False

impl' :: Bool -> Bool -> Bool
impl' a b = or' b $ not' a

equ' :: Bool -> Bool -> Bool
equ' True True = True
equ' False False = True
equ' _ _ = False

--equ'      = (==)
--and'      = (&&)
--or'       = (||)
--nand' a b = not   $ and' a b
--nor'  a b = not   $ or'  a b
--xor'  a b = not   $ equ' a b
--impl' a b = or' b $ not a

table :: (Bool -> Bool -> Bool) -> IO ()
table f = mapM_ putStrLn [line a b | a <- [True, False], b <- [True, False]]
  where line a b = show a ++ " " ++ show b ++ " " ++ show (f a b)

-- Problem 48
infixl 3 `equ'`
infixl 4 `or'`
infixl 4 `nor'`
infixl 5 `xor'`
infixl 6 `and'`
infixl 6 `nand'`

truths :: Int -> [[Bool]]
truths 0 = [[]]
truths n = [True,False] >>= \b -> map (b :) (truths (n - 1))

tablen :: Int -> ([Bool] -> Bool) -> IO ()
tablen n f = mapM_ putStrLn [line a ++ "=> " ++ show (f a) | a <- truths n]
  where line = unwords . map (\x -> show x ++ (if x then "  " else " "))

-- Problem 49
gray :: Int -> [String]
gray 0 = [""]
gray n = foldr (\x xs -> ("0" ++ x) : ("1" ++ x) : xs) [] $ gray (n - 1)
