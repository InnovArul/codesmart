import pandas as pd

def to_latex(df):
    num_columns = len(df.columns)
    column_format =  '|c|' + '|'.join(['c']*num_columns) + '|' # |c|c|c|c|
    print(df.to_latex(longtable=True, bold_rows=True, column_format=column_format))


def display_table(table, is_latex_output_needed=False, is_transpose=False):
    df = []
    if isinstance(table, dict):
        df = pd.DataFrame.from_dict(table)
    else:
        df = pd.DataFrame(table)
    
    if is_transpose:
        df = df.T

    print(df)
    
    if is_latex_output_needed:
        print('\n')
        print(to_latex(df))
    
    print('\n')