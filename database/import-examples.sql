-- Import example sentences for HSK 1 vocabulary
-- Based on HSK 1_Flash cards_(500).csv

UPDATE vocabulary SET example = 
'1. 我爱你。
I love you.
ငါမင်းကိုချစ်တယ်။

2. 妈妈爱我。
Mom loves me.
အမေက ငါ့ကိုချစ်တယ်။

3. 他爱看书。
He loves reading books.
သူ စာဖတ်ရတာကို နှစ်သက်တယ်။'
WHERE hanzi = '爱' AND hsk_level = 1;

UPDATE vocabulary SET example = 
'1. 你的爱好是什么？
What is your hobby?
မင်းရဲ့ ဝါသနာက ဘာလဲ။

2. 我的爱好是唱歌。
My hobby is singing.
ငါ့ရဲ့ ဝါသနာက သီချင်းဆိုခြင်း ဖြစ်တယ်။

3. 他有很多爱好。
He has many hobbies.
သူမှာ ဝါသနာအမျိုးစုံ ရှိတယ်။'
WHERE hanzi = '爱好' AND hsk_level = 1;

-- Add more examples for other common HSK 1 words
UPDATE vocabulary SET example = 
'1. 我是中国人。
I am Chinese.
ငါက တရုတ်လူမျိုးဖြစ်တယ်။

2. 他是中国人。
He is Chinese.
သူက တရုတ်လူမျိုးဖြစ်တယ်။

3. 他们是中国人。
They are Chinese.
သူတို့က တရုတ်လူမျိုးတွေဖြစ်တယ်။'
WHERE hanzi = '人' AND hsk_level = 1;

UPDATE vocabulary SET example = 
'1. 我吃饭。
I eat rice/meal.
ငါထမင်းစားတယ်။

2. 他吃饭了。
He has eaten.
သူထမင်းစားပြီးပြီ။

3. 我们一起吃饭吧。
Let\'s eat together.
ငါတို့အတူထမင်းစားကြစို့။'
WHERE hanzi = '吃' AND hsk_level = 1;

UPDATE vocabulary SET example = 
'1. 我喜欢喝茶。
I like to drink tea.
ငါလက်ဖက်ရည်သောက်တယ်။

2. 你喜欢什么？
What do you like?
မင်းဘာကိုနှစ်သက်လဲ။

3. 他喜欢看书。
He likes reading books.
သူစာဖတ်ရတာကိုနှစ်သက်တယ်။'
WHERE hanzi = '喜欢' AND hsk_level = 1;
