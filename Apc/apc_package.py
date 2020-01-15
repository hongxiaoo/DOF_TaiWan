from datetime import datetime
from pickle import load
from re import findall, S
from tool import *


with open('apc_package_source.pkl', 'rb') as pkl:
    pkl_list = load(pkl)
summon_stk, apc_package, job_dict = pkl_list

# 获取当前日期，做ID计数器
start_id = int(datetime.now().strftime('%Y%m%d') + '00')
# 获取主要工作目录
main_dir = GetDesktopPath() + '\\extract'
# aic.lst
aic_list = lst2list(main_dir + '\\aicharacter\\aicharacter.lst')


def get_equ_ids(path):
    if os.path.splitext(path)[1] == '.aic':
        with open(path, 'r+', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            p = '`(.*)`'
            apc_name = findall(p, content)[0]
            if '''[equipment]
	''' in content and '[/equipment]' in content:
                equ_ids = findall('''\[equipment\](.*)\[/equipment\]''', content, S)[0].strip().split('\t')[::3]
                # print(equ_ids)
                return apc_name, equ_ids
    else:
        return False


def creak_new_stk_file(stk_id, main_file_path, content):
    iep(main_file_path)
    new_path = main_file_path + '\\{stk_code}.stk'.format(stk_code=stk_id)
    lp = fp2lp(new_path)
    with open(new_path, 'w', encoding='utf-8') as new_file:
        new_file.write(content)

    return stk_id + '\n' + lp + '\n'


not_in_lst_apc = []
lst_content = ''
cash_shop_content = ''
cash_shop = 500000
apc_equipments = []

for file_path in laf(main_dir + '\\aicharacter'):
    apc_id = lp2id(fp2lp(file_path), aic_list)
    # 导出不在lst中apc
    if os.path.splitext(file_path)[1] == '.aic' and apc_id is False:
        not_in_lst_apc.append(fp2lp(file_path))
        continue

    result = get_equ_ids(file_path)

    if result is False or result is None:
        continue

    equipment_content = ''
    is_exit_flag = ''
    for equ_id in result[1]:
        is_exit_flag += equ_id
        equipment_content += '	{id}	1	\n'.format(id=equ_id)

    if is_exit_flag in apc_equipments:
        continue

    apc_equipments.append(is_exit_flag)

    # 新建召唤APC消耗品的stk文件
    apc_stk = summon_stk.format(apc_name=result[0], id=apc_id)
    start_id += 1
    lst_content += creak_new_stk_file(str(start_id), main_dir + '\\stackable\\apc_package\\apc_summon_card', apc_stk)

    # 加上一个召唤APC的消耗品
    equipment_content += '	{apc_stk_id}	1	'.format(apc_stk_id=str(start_id))

    # 新建APC礼包stk文件
    # 确定可使用职业
    suitble_job = 'all'
    for job in ['atmagician', 'atfighter', 'thief', 'atgunner', 'priest', 'magician', 'gunner', 'fighter', 'swordman']:
        if job in file_path:
            suitble_job = job_dict[job]
            break
    apc_pack = apc_package.format(apc_name=result[0], content=equipment_content, suitable_job=suitble_job)
    start_id += 1
    lst_content += creak_new_stk_file(str(start_id), main_dir + '\\stackable\\apc_package', apc_pack)
    cash_shop_content += '	{cash_shop_id}	{id}	0	0	500	`「{apc_name}」 · cos礼包`	2	0	-1	-1	\n'.format(
        cash_shop_id=str(cash_shop),
        id=start_id,
        apc_name=result[0])
    cash_shop += 1

# 导出不在lst中apc
with open(main_dir + '\\不在lst中的APC.txt', 'w+') as notinlstapc:
    flag = 0
    for element in not_in_lst_apc:
        notinlstapc.write(str(flag) + '\t' + element + '\n')
        flag += 1

with open(main_dir + '\\new_stackable.lst', 'w') as stk_new_lst:
    stk_new_lst.write(lst_content)

with open(main_dir + '\\newcashshop.etc', 'w', encoding='utf-8') as cash_new_lst:
    cash_new_lst.write(cash_shop_content)
