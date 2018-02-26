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

def get_course_ids_names(contents):
    # for each semester, go through the details and collect unique faculty names
    course_id_names = {}
    for semester, details in contents.items():
        for course_id, course_name in zip(details['Course No'], details['Course Name']):
            course_norm_id = text_normalization(course_id)
            course_norm_name = text_normalization(course_name)
            
            # if the course is not already seen, add it to the list
            if course_norm_id not in course_id_names:
                course_id_names[course_norm_id] = []
                
            # some courses would have multiple names per semester, so collect those names as well
            if course_norm_name not in course_id_names[course_norm_id]:
                course_id_names[course_norm_id].append(course_norm_name)

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
            
            course_details_string = ''
            
            if faculty in course_details_by_faculty and semester in course_details_by_faculty[faculty]:

                for course_id_strength in course_details_by_faculty[faculty][semester]:
                    if course_id_strength[1] != 0:
                        course_details_string += course_id_strength[0] + ' (' + str(course_id_strength[1]) + ')\n'
            
            ws.write(rowx, colx, course_details_string)
        

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
        course_names = course_id_names[course_id]
        rowx += 1
        ws.write(rowx, 0, course_id)
        ws.write(rowx, 1, ', '.join(course_names))

def write_into_excel_sheet(course_details_by_faculty, faculties, course_id_names, 
                            start_year, end_year, all_semesters):
    wb = xlwt.Workbook()
    
    # write the faculty course details       
    write_faculty_course_details(wb, course_details_by_faculty, faculties, course_id_names, 
                            start_year, end_year, all_semesters)
    
    # write the names of courses with ids
    write_course_details(wb, course_id_names)
    
    wb.save("myworkbook.xls")    


if __name__ == '__main__':
    # read the csv files containing faculty and course details
    contents = read_csv_files()
    
    # collect unique faculty names
    faculties = collect_faculty_names(contents)
    #print(('faculties', faculties, len(faculties)))
    
    # collect unique course IDs
    course_id_names = get_course_ids_names(contents)
    #print(('course_id_names', course_id_names, len(course_id_names)))
    
    # collect course details for each faculty
    course_details_by_faculty = collect_courses_by_faculty(contents)
    print(course_details_by_faculty['CHESTER REBEIRO'])
    
    # write the details into excel sheet
    write_into_excel_sheet(course_details_by_faculty, faculties, 
                           course_id_names, 2015, 2018, list(contents))
