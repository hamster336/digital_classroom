export interface Classroom {
    id: string;
    name: string;
    section: string;
    roomNumber: string;
    capacity: number;
    type: 'Theory' | 'Lab' | 'Seminar';
    status: 'Available' | 'Maintenance' | 'Full';
}

export interface Subject {
    id: string;
    name: string;
    code: string;
    department: 'Science' | 'Arts' | 'Commerce' | 'Technology';
    credits: number;
    description: string;
}

export interface Teacher {
    id: string;
    name: string;
    email: string;
    subjects: string[]; // Subject IDs
}

export interface Student {
    id: string;
    name: string;
    email: string;
    classroomId: string;
}

export interface Notice {
    id: string;
    title: string;
    content: string;
    date: string;
}

// Data Seeding for Nepalese Engineering Context
const nepaliNames = [
    "Ram Bahadur Thapa", "Sumi Khadka", "Prabin Shrestha", "Aarati Paudel", "Sujan Magar",
    "Deepa Rai", "Manish Tamang", "Bipina Gurung", "Kiran Acharya", "Sita Devi Mahato",
    "Roshan Karki", "Anjali Lama", "Bibek Sharma", "Pooja Biswakarma", "Sagar Kc",
    "Nabina Adhikari", "Dipendra Bhattarai", "Pratima Ghimire", "Rojan Shah", "Sneha Jha",
    "Arjun Rijal", "Manisha Giri", "Santosh Khetri", "Rabina Baniya", "Umesh Basnet",
    "Sapana Regmi", "Amit Dangol", "Sunita Maharjan", "Prakash Shakya", "Bandana Bajracharya",
    "Mahesh Joshi", "Rupa Tripathi", "Bijay Lamsal", "Geeta Aryal", "Prem Neupane"
];

const studentLastNames = ["Shrestha", "Karki", "Paudel", "Thapa", "Magar", "Tamang", "Gurung", "Acharya", "Mahato", "Lama", "Sharma", "Biswakarma", "Kc", "Adhikari", "Bhattarai", "Ghimire", "Shah", "Jha", "Rijal", "Giri", "Khetri", "Baniya", "Basnet", "Regmi", "Dangol", "Maharjan", "Shakya", "Bajracharya", "Joshi", "Tripathi"];

const engineeringSubjects = [
    { name: "Object Oriented Programming", code: "CT101", dept: "Technology", credits: 4, desc: "C++ and Java based OOP concepts." },
    { name: "Data Structures & Algorithms", code: "CT102", dept: "Technology", credits: 4, desc: "Fundamental algorithms and complexity analysis." },
    { name: "Digital Logic", code: "EX101", dept: "Technology", credits: 3, desc: "Logic gates, flip-flops, and circuit design." },
    { name: "Microprocessor", code: "EX102", dept: "Technology", credits: 4, desc: "8085/8086 architecture and assembly." },
    { name: "Database Management System", code: "CT201", dept: "Technology", credits: 3, desc: "SQL, normalization, and DB optimization." },
    { name: "Theory of Computation", code: "CT202", dept: "Technology", credits: 3, desc: "Automata, DFA, NFA, and Turing machines." },
    { name: "Computer Graphics", code: "CT203", dept: "Technology", credits: 3, desc: "Raster graphics and transformation algorithms." },
    { name: "Software Engineering", code: "CT301", dept: "Technology", credits: 3, desc: "Agile, Waterfall, and SDLC models." },
    { name: "Artificial Intelligence", code: "CT302", dept: "Technology", credits: 4, desc: "Machine learning and heuristic search." },
    { name: "Compiler Design", code: "CT401", dept: "Technology", credits: 4, desc: "Lexical and syntax analysis." },
    { name: "Structural Analysis I", code: "CE101", dept: "Science", credits: 3, desc: "Static determinacy and energy methods." },
    { name: "Structural Analysis II", code: "CE102", dept: "Science", credits: 3, desc: "Indeterminate structures and slope deflection." },
    { name: "Surveying I", code: "CE103", dept: "Science", credits: 4, desc: "Linear measurements and leveling." },
    { name: "Surveying II", code: "CE104", dept: "Science", credits: 4, desc: "Theodolite and tachometry." },
    { name: "Hydraulics", code: "CE201", dept: "Science", credits: 3, desc: "Fluid flow and open channel properties." },
    { name: "Soil Mechanics", code: "CE202", dept: "Science", credits: 4, desc: "Geotechnical properties of Nepalese soil." },
    { name: "Foundation Engineering", code: "CE301", dept: "Science", credits: 3, desc: "Shallow and deep foundation design." },
    { name: "Design of RCC Structures", code: "CE302", dept: "Science", credits: 4, desc: "IS 456 and NBC codes based design." },
    { name: "Transportation Engineering", code: "CE401", dept: "Science", credits: 3, desc: "Highway and airport design principles." },
    { name: "Estimating & Costing", code: "CE402", dept: "Science", credits: 3, desc: "Quantity survey and rate analysis." },
    { name: "Engineering Physics", code: "SH101", dept: "Science", credits: 4, desc: "Optics, electromagnetics, and modern physics." },
    { name: "Engineering Chemistry", code: "SH102", dept: "Science", credits: 4, desc: "Organic and physical chemistry in engineering." },
    { name: "Engineering Mathematics I", code: "SH103", dept: "Science", credits: 4, desc: "Calculus and linear algebra." },
    { name: "Engineering Mathematics II", code: "SH104", dept: "Science", credits: 4, desc: "Vectors and differential equations." },
    { name: "Applied Mechanics", code: "SH105", dept: "Science", credits: 3, desc: "Equilibrium and virtual work." },
    { name: "Engineering Drawing", code: "SH106", dept: "Science", credits: 3, desc: "Orthographic and isometric projections." },
    { name: "Communication English", code: "SH201", dept: "Arts", credits: 2, desc: "Professional writing and presentation." },
    { name: "Engineering Economics", code: "SH301", dept: "Commerce", credits: 3, desc: "Time value of money and project cost." },
    { name: "Organization & Management", code: "SH401", dept: "Commerce", credits: 3, desc: "Entrepreneurship and HRM for engineers." },
    { name: "Probability & Statistics", code: "SH202", dept: "Science", credits: 3, desc: "Statistical analysis for data science." },
    { name: "Distributed Systems", code: "CT405", dept: "Technology", credits: 3, desc: "Concurrency and consensus algorithms." },
    { name: "Mobile Computing", code: "CT406", dept: "Technology", credits: 3, desc: "Android and iOS development frameworks." },
    { name: "Big Data Technologies", code: "CT407", dept: "Technology", credits: 3, desc: "Hadoop, Spark, and NoSQL databases." },
    { name: "Internet of Things", code: "EX405", dept: "Technology", credits: 3, desc: "Sensors, actuators, and ESP32 programming." },
    { name: "Digital Signal Processing", code: "EX406", dept: "Technology", credits: 4, desc: "FFT, DFT, and filter design." },
    { name: "Project Management", code: "CE405", dept: "Commerce", credits: 3, desc: "PERT/CPM and risk management." },
    { name: "Seismic Engineering", code: "CE406", dept: "Science", credits: 3, desc: "Earthquake resistant design for Nepal." },
    { name: "Water Supply Engineering", code: "CE205", dept: "Science", credits: 3, desc: "Design of water distribution networks." },
    { name: "Irrigation Engineering", code: "CE305", dept: "Science", credits: 3, desc: "Canal design and water requirements." },
    { name: "Power Systems I", code: "EE101", dept: "Technology", credits: 4, desc: "Transmission and distribution principles." },
    { name: "Power Systems II", code: "EE102", dept: "Technology", credits: 4, desc: "Stability and protection of power grids." },
    { name: "Electric Circuits", code: "EE103", dept: "Technology", credits: 3, desc: "KCL, KVL, and network theorems." },
    { name: "Control Systems", code: "EE201", dept: "Technology", credits: 4, desc: "Transfer functions and PID control." },
    { name: "Embedded Systems", code: "EX205", dept: "Technology", credits: 3, desc: "RTOS and FPGA programming." },
    { name: "Concrete Technology", code: "CE108", dept: "Science", credits: 2, desc: "Mix design and material testing." },
    { name: "Discrete Structure", code: "SH120", dept: "Science", credits: 3, desc: "Set theory and graph theory." },
    { name: "Computer Network", code: "CT220", dept: "Technology", credits: 3, desc: "TCP/IP layers and routing." },
    { name: "Cloud Computing", code: "CT225", dept: "Technology", credits: 3, desc: "AWS and Azure service paradigms." },
    { name: "Machine Learning", code: "CT320", dept: "Technology", credits: 4, desc: "Regressions and deep learning models." },
    { name: "Data Warehousing", code: "CT325", dept: "Technology", credits: 3, desc: "ETL processes and OLAP cubes." },
    { name: "Network Security", code: "CT330", dept: "Technology", credits: 3, desc: "Cryptography and firewall design." },
    { name: "Real Time Systems", code: "CT335", dept: "Technology", credits: 3, desc: "Scheduling in RTOS environment." },
    { name: "Project I", code: "CT499", dept: "Technology", credits: 2, desc: "Final year minor project." },
    { name: "Project II", code: "CT500", dept: "Technology", credits: 4, desc: "Final year major project development." },
    { name: "Environmental Engineering", code: "CE408", dept: "Science", credits: 3, desc: "Solid waste and pollution management." },
    { name: "Bridge Engineering", code: "CE410", dept: "Science", credits: 3, desc: "Analysis of suspension and truss bridges." },
    { name: "Applied Sociology", code: "SH405", dept: "Arts", credits: 2, desc: "Impact of engineering on Nepalese society." },
    { name: "Disaster Risk Management", code: "SH410", dept: "Science", credits: 2, desc: "Landslide and flood risk assessment." },
    { name: "Hydropower Engineering", code: "CE310", dept: "Technology", credits: 4, desc: "Hydro-mechanical design for MHPs." },
    { name: "Instrumentation I", code: "EX210", dept: "Technology", credits: 3, desc: "Transducers and measurement devices." },
];

export const subjects: Subject[] = engineeringSubjects.map((s, i) => ({
    id: `s-${i + 1}`,
    name: s.name,
    code: s.code,
    department: s.dept as any,
    credits: s.credits,
    description: s.desc
}));

export const classrooms: Classroom[] = Array.from({ length: 55 }, (_, i) => {
    const isLab = i % 3 === 0;
    const isCivil = i % 2 === 0;
    return {
        id: `c-${i + 1}`,
        name: isLab ? `${isCivil ? 'Civil' : 'Computer'} Lab ${i % 5 + 1}` : `${isCivil ? 'Civil' : 'BCT/BEL'} Block - ${100 + i}`,
        section: ['E', 'A', 'B', 'A', 'B', 'B', 'A', 'A'][i % 8],
        roomNumber: `${100 + i + 1}`,
        capacity: 24 + (i % 24),
        type: isLab ? 'Lab' : (i % 5 === 0 ? 'Seminar' : 'Theory'),
        status: (i % 12 === 0 ? 'Maintenance' : (i % 4 === 0 ? 'Full' : 'Available')) as any,
    };
});

export const teachers: Teacher[] = nepaliNames.map((name, i) => ({
    id: `t-${i + 1}`,
    name: name,
    email: `${name.split(' ')[0].toLowerCase()}.${name.split(' ')[name.split(' ').length - 1].toLowerCase()}@academia.edu.np`,
    subjects: [`s-${(i * 1) % 55 + 1}`, `s-${(i * 2) % 55 + 1}`],
}));

export const students: Student[] = Array.from({ length: 155 }, (_, i) => {
    const firstName = nepaliNames[i % nepaliNames.length].split(' ')[0];
    const lastName = studentLastNames[Math.floor(i / 5) % studentLastNames.length];
    return {
        id: `st-${i + 1}`,
        name: `${firstName} ${lastName}`,
        email: `student.${i + 1}@student.ioe.edu.np`,
        classroomId: `c-${(i % 55) + 1}`,
    };
});

export const notices: Notice[] = Array.from({ length: 42 }, (_, i) => ({
    id: `n-${i + 1}`,
    title: i % 2 === 0 ? `Exam Schedule for Sem ${i % 8 + 1}` : `Workshop on ${engineeringSubjects[i % 50].name}`,
    content: `Attention all students, this is to inform you about notice #${i + 1} which concerns the upcoming academic calendar and events.`,
    date: new Date(Date.now() - i * 36 * 60 * 60 * 1000).toISOString().split('T')[0],
}));
