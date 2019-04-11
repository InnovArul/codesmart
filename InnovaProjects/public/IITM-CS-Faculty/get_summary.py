import os, sys
import numpy as np
import pandas as pd
import xlwt

data_root = './data'

# csv file contents format

#Index(['Sno', 'Slot', 'Additional Slot', 'Course No', 'Course Name',
#       'Instructor Name', 'Old Credit', 'New Credit', 'Room', 'Prereq',
#       'Coordinator', 'CC Chairperson', 'Strength', 'Allocation Type'],
#      dtype='object')

project_font = xlwt.easyfont('colour light_blue, bold True')
core_font = xlwt.easyfont('colour red, bold True')
elective_font = xlwt.easyfont('colour green, bold True')
bg_style = xlwt.easyxf('pattern: pattern solid, fore_colour white;')

def read_csv_files():
    contents = {}
    
    # for each file in the folder, read the contents
    for filename_with_ext in sorted(os.listdir(data_root)):
        full_path = os.path.join(data_root, filename_with_ext)
        filename = os.path.splitext(filename_with_ext)[0]
        contents[filename] = pd.read_csv(full_path, delimiter=',')
    
    return contents

def text_normalization(text):
    return text.strip().upper().replace("PROF. ", "")

def collect_faculty_names(contents):
    # for each semester, go through the details and collect unique faculty names
    faculties = []
    for semester, details in contents.items():
        for faculty_name in details['Instructor Name']:
            faculty_norm_name = text_normalization(faculty_name)
            if faculty_norm_name not in faculties:
                faculties.append(faculty_norm_name)
    
    return sorted(faculties)

def get_type_of_course(course_id, course_name):
    course_name_lower = course_name.lower()
    
    # determine type of course (CORE, ELECTIVE)
    if('project' in course_name_lower
        or 'seminar' in course_name_lower):
        course_type = 'PROJECT'
    elif(course_id.startswith('CS1')
        or course_id.startswith('CS2')
        or course_id.startswith('CS3')):
        course_type = 'CORE'
    else:
        course_type = 'ELECTIVE'
    
    return course_type

def get_course_ids_names(contents):
    # for each semester, go through the details and collect unique faculty names
    course_id_names = {}
    for semester, details in contents.items():
        for course_id, course_name in zip(details['Course No'], details['Course Name']):
            course_norm_id = text_normalization(course_id)
            course_norm_name = text_normalization(course_name)
            
            # if the course is not already seen, add it to the list
            if course_norm_id not in course_id_names:
                course_id_names[course_norm_id] = {}
                course_id_names[course_norm_id]['name'] = []
                course_id_names[course_norm_id]['type'] = []
            
            current_course_names = course_id_names[course_norm_id]['name']
            current_course_types = course_id_names[course_norm_id]['type']
            
            # some courses would have multiple names per semester, so collect those names as well
            if course_norm_name not in current_course_names:
                current_course_names.append(course_norm_name)
            
            current_course_types.append(get_type_of_course(course_norm_id, course_norm_name))

    return course_id_names

def collect_courses_by_faculty(contents):
    courses_by_faculty = {}

    # for each semester, collect the courses for each faculty
    for semester, details in contents.items():        
        for course_id, instructor_name, strength in zip(details['Course No'], details['Instructor Name'], details['Strength']):
            course_norm_id = text_normalization(course_id)
            instructor_norm_name = text_normalization(instructor_name)
            
            # check if the instructor name is in Buffer
            if instructor_norm_name not in courses_by_faculty:
                courses_by_faculty[instructor_norm_name] = {}
            
            # check if the instructor name's semester is in buffer
            if semester not in courses_by_faculty[instructor_norm_name]:
                courses_by_faculty[instructor_norm_name][semester] = []
            
            if (course_norm_id, strength) not in courses_by_faculty[instructor_norm_name][semester]:
                courses_by_faculty[instructor_norm_name][semester].append((course_norm_id, strength))
        
    return courses_by_faculty

def write_faculty_course_details(wb, course_details_by_faculty, faculties, course_id_names, 
                            start_year, end_year, all_semesters):
    ws = wb.add_sheet("Course-Faculty-details")
    
    # write the heading
    rowx = 0
        
    # Add headings with styling and frozen first row
    ws.set_panes_frozen(True) # frozen headings instead of split panes
    ws.set_horz_split_pos(rowx+1) # in general, freeze after last heading row
    ws.set_remove_splits(True) # if user does unfreeze, don't leave a split there
    
    heading_xf = xlwt.easyxf('font: bold on; align: wrap on, vert centre, horiz center')
    headings = ['Faculty']
    semesters = []
    for year in range(start_year, end_year+1):
        semesters.append('JAN-MAY-' + str(year))
        semesters.append('JUL-NOV-' + str(year))

    headings += semesters
    for colx, value in enumerate(headings):
        ws.write(rowx, colx, value, heading_xf)
    
    ws.row(0).height = 1000
    ws.col(0).width = 5000

    for faculty in faculties:
        rowx += 1
        ws.row(rowx).height = 2000
        colx = 0
        ws.write(rowx, colx, faculty, heading_xf)
        for semester in semesters:
            
            colx += 1
            ws.col(0).width = 4000
            
            course_details = ()
            
            if faculty in course_details_by_faculty and semester in course_details_by_faculty[faculty]:
                for course_id_strength in course_details_by_faculty[faculty][semester]:
                    course_id = course_id_strength[0]
                    course_strength = course_id_strength[1]
                    course_types = course_id_names[course_id]['type']
                    font = get_font_from_course_type(course_types)
                    if course_strength != 0 and 'PROJECT' not in course_types:
                        course_details += ((course_id + ' (' + str(course_strength) + ')\n', font), )
        
            ws.write_rich_text(rowx, colx, course_details, bg_style)
    
def get_font_from_course_type(course_types):
    font = elective_font
    if 'PROJECT' in course_types:
        font = project_font
    elif 'CORE' in course_types:
        font = core_font
    
    return font

def write_course_details(wb, course_id_names):
    ws = wb.add_sheet("Course-details")
    
    # write the heading
    rowx = 0
        
    # Add headings with styling and frozen first row
    ws.set_panes_frozen(True) # frozen headings instead of split panes
    ws.set_horz_split_pos(rowx+1) # in general, freeze after last heading row
    ws.set_remove_splits(True) # if user does unfreeze, don't leave a split there
    
    heading_xf = xlwt.easyxf('font: bold on; align: wrap on, vert centre, horiz center')
    headings = ['Course ID', 'Course name']
    
    for colx, value in enumerate(headings):
        ws.write(rowx, colx, value, heading_xf)
    
    ws.row(0).height = 1000
    ws.col(0).width = 5000

    course_ids = sorted(list(course_id_names.keys()))
    for course_id in course_ids:
        course_names = course_id_names[course_id]['name']
        rowx += 1
        font = get_font_from_course_type(course_id_names[course_id]['type'])
        ws.write_rich_text(rowx, 0, ((course_id, font),), bg_style)
        ws.write_rich_text(rowx, 1, ((', '.join(course_names), font),), bg_style)

def write_into_excel_sheet(course_details_by_faculty, faculties, course_id_names_types, 
                            start_year, end_year, all_semesters):
    wb = xlwt.Workbook()
    
    # write the faculty course details       
    write_faculty_course_details(wb, course_details_by_faculty, faculties, course_id_names_types, 
                                 start_year, end_year, all_semesters)
    
    # write the names of courses with ids
    write_course_details(wb, course_id_names_types)
    
    wb.save("myworkbook.xls")    


if __name__ == '__main__':
    # read the csv files containing faculty and course details
    contents = read_csv_files()
    
    # collect unique faculty names
    faculties = collect_faculty_names(contents)
    #print(('faculties', faculties, len(faculties)))
    
    # collect unique course IDs
    course_id_names_types = get_course_ids_names(contents)
    #print(('course_id_names', course_id_names, len(course_id_names)))
    
    # collect course details for each faculty
    course_details_by_faculty = collect_courses_by_faculty(contents)
    print(course_details_by_faculty['CHESTER REBEIRO'])
    
    # write the details into excel sheet
    write_into_excel_sheet(course_details_by_faculty, faculties, 
                           course_id_names_types, 2015, 2018, list(contents))
