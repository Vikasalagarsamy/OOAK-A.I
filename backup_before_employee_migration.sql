--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Homebrew)
-- Dumped by pg_dump version 15.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO vikasalagarsamy;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: vikasalagarsamy
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounting_workflows; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.accounting_workflows (
    id integer NOT NULL,
    quotation_id integer,
    payment_id integer,
    instruction_id integer,
    status character varying(30) DEFAULT 'pending_processing'::character varying,
    total_amount numeric NOT NULL,
    payment_type character varying(20) NOT NULL,
    processed_by character varying(255),
    processed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.accounting_workflows OWNER TO vikasalagarsamy;

--
-- Name: accounting_workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.accounting_workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounting_workflows_id_seq OWNER TO vikasalagarsamy;

--
-- Name: accounting_workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.accounting_workflows_id_seq OWNED BY public.accounting_workflows.id;


--
-- Name: action_recommendations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.action_recommendations (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    recommendation_type text NOT NULL,
    priority text NOT NULL,
    confidence_score numeric NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    suggested_action text NOT NULL,
    expected_impact jsonb DEFAULT '{}'::jsonb NOT NULL,
    reasoning text NOT NULL,
    is_completed boolean DEFAULT false NOT NULL,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone
);


ALTER TABLE public.action_recommendations OWNER TO vikasalagarsamy;

--
-- Name: action_recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.action_recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.action_recommendations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: action_recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.action_recommendations_id_seq OWNED BY public.action_recommendations.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.activities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    action_type character varying(50) NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id text NOT NULL,
    entity_name character varying(255) NOT NULL,
    description text NOT NULL,
    user_id uuid,
    user_name character varying(255),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.activities OWNER TO vikasalagarsamy;

--
-- Name: ai_behavior_settings; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_behavior_settings (
    id integer NOT NULL,
    setting_key character varying(100) NOT NULL,
    setting_value jsonb NOT NULL,
    description text,
    category character varying(50) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_behavior_settings OWNER TO vikasalagarsamy;

--
-- Name: ai_behavior_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_behavior_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_behavior_settings_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_behavior_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_behavior_settings_id_seq OWNED BY public.ai_behavior_settings.id;


--
-- Name: ai_communication_tasks; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_communication_tasks (
    id integer NOT NULL,
    quotation_id integer,
    conversation_session_id integer,
    task_type character varying(50) NOT NULL,
    title text NOT NULL,
    description text,
    priority character varying(20) DEFAULT 'medium'::character varying,
    assigned_to_employee_id integer,
    due_date timestamp without time zone,
    status character varying(20) DEFAULT 'pending'::character varying,
    ai_reasoning text,
    trigger_message_id integer,
    created_by_ai boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.ai_communication_tasks OWNER TO vikasalagarsamy;

--
-- Name: ai_communication_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_communication_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_communication_tasks_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_communication_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_communication_tasks_id_seq OWNED BY public.ai_communication_tasks.id;


--
-- Name: ai_configurations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_configurations (
    id integer NOT NULL,
    config_key character varying(100) NOT NULL,
    config_type character varying(50) NOT NULL,
    config_value text NOT NULL,
    version integer DEFAULT 1,
    is_active boolean DEFAULT true,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    description text
);


ALTER TABLE public.ai_configurations OWNER TO vikasalagarsamy;

--
-- Name: ai_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_configurations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_configurations_id_seq OWNED BY public.ai_configurations.id;


--
-- Name: ai_contacts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone text,
    country_code text,
    name text,
    source_id text,
    source_url text,
    internal_lead_source text,
    internal_closure_date timestamp without time zone,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.ai_contacts OWNER TO vikasalagarsamy;

--
-- Name: ai_decision_log; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_decision_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id text,
    decision_type text NOT NULL,
    decision_data jsonb NOT NULL,
    model_version text DEFAULT 'v1.0'::text,
    confidence_score numeric,
    execution_time integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_decision_log OWNER TO vikasalagarsamy;

--
-- Name: ai_performance_tracking; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_performance_tracking (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    model_type text NOT NULL,
    prediction_data jsonb NOT NULL,
    actual_outcome jsonb,
    accuracy_score numeric,
    confidence_score numeric,
    model_version text DEFAULT 'v1.0'::text,
    feedback_loop_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_performance_tracking OWNER TO vikasalagarsamy;

--
-- Name: ai_prompt_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_prompt_templates (
    id integer NOT NULL,
    template_name character varying(100) NOT NULL,
    template_content text NOT NULL,
    variables jsonb DEFAULT '{}'::jsonb,
    category character varying(50) NOT NULL,
    is_default boolean DEFAULT false,
    version integer DEFAULT 1,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_prompt_templates OWNER TO vikasalagarsamy;

--
-- Name: ai_prompt_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_prompt_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_prompt_templates_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_prompt_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_prompt_templates_id_seq OWNED BY public.ai_prompt_templates.id;


--
-- Name: ai_recommendations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_recommendations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    recommendation_type text NOT NULL,
    recommendation_data jsonb NOT NULL,
    confidence_score numeric NOT NULL,
    context_data jsonb DEFAULT '{}'::jsonb,
    applied boolean DEFAULT false,
    feedback_score integer,
    expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_recommendations OWNER TO vikasalagarsamy;

--
-- Name: ai_tasks; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_tasks (
    id integer NOT NULL,
    task_title character varying(255) NOT NULL,
    task_description text,
    priority character varying(20) DEFAULT 'medium'::character varying,
    status character varying(20) DEFAULT 'pending'::character varying,
    due_date timestamp with time zone,
    category character varying(50),
    assigned_to character varying(255),
    assigned_by character varying(255),
    metadata jsonb,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    client_name character varying(255),
    business_impact text,
    ai_reasoning text,
    estimated_value numeric,
    lead_id integer,
    quotation_id integer,
    actual_hours numeric,
    quality_rating integer,
    assigned_to_employee_id integer,
    task_type character varying(50),
    completion_notes text,
    employee_id integer
);


ALTER TABLE public.ai_tasks OWNER TO vikasalagarsamy;

--
-- Name: ai_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_tasks_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_tasks_id_seq OWNED BY public.ai_tasks.id;


--
-- Name: analytics_cache; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.analytics_cache (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cache_key text NOT NULL,
    cache_data jsonb NOT NULL,
    cache_type text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.analytics_cache OWNER TO vikasalagarsamy;

--
-- Name: analytics_metrics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.analytics_metrics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    metric_name text NOT NULL,
    metric_type text NOT NULL,
    metric_value numeric NOT NULL,
    metric_unit text DEFAULT 'count'::text,
    dimensions jsonb DEFAULT '{}'::jsonb,
    time_period text NOT NULL,
    recorded_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.analytics_metrics OWNER TO vikasalagarsamy;

--
-- Name: branches; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.branches (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(255) NOT NULL,
    address text NOT NULL,
    phone character varying(50),
    email character varying(255),
    manager_id integer,
    is_remote boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    branch_code character varying(30),
    location character varying(255)
);


ALTER TABLE public.branches OWNER TO vikasalagarsamy;

--
-- Name: branches_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.branches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.branches_id_seq OWNER TO vikasalagarsamy;

--
-- Name: branches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.branches_id_seq OWNED BY public.branches.id;


--
-- Name: bug_attachments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.bug_attachments (
    id bigint NOT NULL,
    bug_id bigint,
    file_name text NOT NULL,
    file_path text NOT NULL,
    file_type text NOT NULL,
    file_size integer NOT NULL,
    uploaded_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bug_attachments OWNER TO vikasalagarsamy;

--
-- Name: bug_comments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.bug_comments (
    id bigint NOT NULL,
    bug_id bigint,
    user_id uuid NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bug_comments OWNER TO vikasalagarsamy;

--
-- Name: bugs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.bugs (
    id bigint NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    severity text NOT NULL,
    status text DEFAULT 'open'::text NOT NULL,
    assignee_id uuid,
    reporter_id uuid NOT NULL,
    due_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bugs OWNER TO vikasalagarsamy;

--
-- Name: business_rules; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.business_rules (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    department text NOT NULL,
    task_type text NOT NULL,
    priority text NOT NULL,
    due_after_hours integer DEFAULT 24 NOT NULL,
    due_after_days integer DEFAULT 1 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    conditions jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.business_rules OWNER TO vikasalagarsamy;

--
-- Name: business_trends; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.business_trends (
    id integer NOT NULL,
    trend_type text NOT NULL,
    trend_period text NOT NULL,
    trend_direction text NOT NULL,
    trend_strength numeric NOT NULL,
    current_value numeric NOT NULL,
    previous_value numeric NOT NULL,
    percentage_change numeric NOT NULL,
    statistical_significance numeric NOT NULL,
    insights jsonb DEFAULT '{}'::jsonb NOT NULL,
    recommendations jsonb DEFAULT '{}'::jsonb NOT NULL,
    analyzed_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.business_trends OWNER TO vikasalagarsamy;

--
-- Name: business_trends_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.business_trends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.business_trends_id_seq OWNER TO vikasalagarsamy;

--
-- Name: business_trends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.business_trends_id_seq OWNED BY public.business_trends.id;


--
-- Name: call_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    call_id character varying(255) NOT NULL,
    overall_sentiment character varying(20),
    sentiment_score numeric DEFAULT 0,
    client_sentiment character varying(20),
    agent_sentiment character varying(20),
    call_intent character varying(255),
    key_topics jsonb DEFAULT '[]'::jsonb,
    business_outcomes jsonb DEFAULT '[]'::jsonb,
    action_items jsonb DEFAULT '[]'::jsonb,
    agent_professionalism_score integer,
    agent_responsiveness_score integer,
    agent_knowledge_score integer,
    agent_closing_effectiveness integer,
    client_engagement_level character varying(20),
    client_interest_level character varying(20),
    client_objection_handling jsonb DEFAULT '[]'::jsonb,
    client_buying_signals jsonb DEFAULT '[]'::jsonb,
    forbidden_words_detected jsonb DEFAULT '[]'::jsonb,
    compliance_issues jsonb DEFAULT '[]'::jsonb,
    risk_level character varying(20),
    talk_time_ratio numeric DEFAULT 1.0,
    interruptions integer DEFAULT 0,
    silent_periods integer DEFAULT 0,
    call_quality_score numeric DEFAULT 7.0,
    quote_discussed boolean DEFAULT false,
    budget_mentioned boolean DEFAULT false,
    timeline_discussed boolean DEFAULT false,
    next_steps_agreed boolean DEFAULT false,
    follow_up_required boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.call_analytics OWNER TO vikasalagarsamy;

--
-- Name: call_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_insights (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    call_id character varying(255) NOT NULL,
    conversion_indicators jsonb DEFAULT '[]'::jsonb,
    objection_patterns jsonb DEFAULT '[]'::jsonb,
    successful_techniques jsonb DEFAULT '[]'::jsonb,
    improvement_areas jsonb DEFAULT '[]'::jsonb,
    decision_factors jsonb DEFAULT '[]'::jsonb,
    pain_points jsonb DEFAULT '[]'::jsonb,
    preferences jsonb DEFAULT '[]'::jsonb,
    concerns jsonb DEFAULT '[]'::jsonb,
    market_trends jsonb DEFAULT '[]'::jsonb,
    competitive_mentions jsonb DEFAULT '[]'::jsonb,
    pricing_feedback jsonb DEFAULT '[]'::jsonb,
    service_feedback jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.call_insights OWNER TO vikasalagarsamy;

--
-- Name: call_transcriptions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_transcriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    call_id character varying(255) NOT NULL,
    task_id uuid,
    lead_id integer,
    client_name character varying(255) NOT NULL,
    sales_agent character varying(255) NOT NULL,
    phone_number character varying(20) NOT NULL,
    duration integer NOT NULL,
    recording_url text,
    transcript text NOT NULL,
    confidence_score numeric DEFAULT 0.8,
    language character varying(10) DEFAULT 'en'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    detected_language character varying(10),
    status character varying(20) DEFAULT 'processing'::character varying,
    notes text,
    call_direction character varying(20) DEFAULT 'outgoing'::character varying,
    call_status character varying(20) DEFAULT 'processing'::character varying
);


ALTER TABLE public.call_transcriptions OWNER TO vikasalagarsamy;

--
-- Name: call_triggers; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_triggers (
    id integer NOT NULL,
    employee_id character varying(20) NOT NULL,
    phone_number character varying(20) NOT NULL,
    client_name character varying(255),
    task_id integer,
    triggered_at timestamp with time zone DEFAULT now(),
    executed_at timestamp with time zone,
    status character varying(20) DEFAULT 'pending'::character varying,
    response_data jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.call_triggers OWNER TO vikasalagarsamy;

--
-- Name: call_triggers_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.call_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.call_triggers_id_seq OWNER TO vikasalagarsamy;

--
-- Name: call_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.call_triggers_id_seq OWNED BY public.call_triggers.id;


--
-- Name: chat_logs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.chat_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone text NOT NULL,
    name text,
    message text NOT NULL,
    reply text NOT NULL,
    channel text DEFAULT 'whatsapp'::text,
    "timestamp" timestamp with time zone DEFAULT now()
);


ALTER TABLE public.chat_logs OWNER TO vikasalagarsamy;

--
-- Name: client_communication_timeline; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.client_communication_timeline (
    id integer NOT NULL,
    quotation_id integer,
    client_phone character varying(20),
    communication_type character varying(20) NOT NULL,
    communication_direction character varying(10) NOT NULL,
    content text,
    "timestamp" timestamp without time zone NOT NULL,
    employee_id integer,
    reference_id integer,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.client_communication_timeline OWNER TO vikasalagarsamy;

--
-- Name: client_communication_timeline_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.client_communication_timeline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_communication_timeline_id_seq OWNER TO vikasalagarsamy;

--
-- Name: client_communication_timeline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.client_communication_timeline_id_seq OWNED BY public.client_communication_timeline.id;


--
-- Name: client_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.client_insights (
    id integer NOT NULL,
    client_name text NOT NULL,
    client_email text,
    client_phone text,
    sentiment_score numeric,
    engagement_level text,
    conversion_probability numeric,
    preferred_communication_method text,
    optimal_follow_up_time text,
    price_sensitivity text,
    decision_timeline_days integer,
    insights jsonb DEFAULT '{}'::jsonb NOT NULL,
    last_analyzed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.client_insights OWNER TO vikasalagarsamy;

--
-- Name: client_insights_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.client_insights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_insights_id_seq OWNER TO vikasalagarsamy;

--
-- Name: client_insights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.client_insights_id_seq OWNED BY public.client_insights.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    client_code character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    company_id integer NOT NULL,
    contact_person character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(50) NOT NULL,
    address text NOT NULL,
    city character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    postal_code character varying(20) NOT NULL,
    country character varying(100) NOT NULL,
    category character varying(20) NOT NULL,
    status character varying(20) NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    country_code character varying(10) DEFAULT '+91'::character varying,
    is_whatsapp boolean DEFAULT false,
    whatsapp_country_code character varying(10),
    whatsapp_number character varying(20),
    has_separate_whatsapp boolean DEFAULT false
);


ALTER TABLE public.clients OWNER TO vikasalagarsamy;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_id_seq OWNER TO vikasalagarsamy;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: communications; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.communications (
    id integer NOT NULL,
    channel_type character varying(50) NOT NULL,
    message_id character varying(255) NOT NULL,
    sender_type character varying(50) NOT NULL,
    sender_id character varying(100),
    sender_name character varying(255),
    recipient_type character varying(50) NOT NULL,
    recipient_id character varying(100),
    recipient_name character varying(255),
    content_type character varying(50) NOT NULL,
    content_text text,
    content_metadata jsonb,
    business_context character varying(100),
    ai_processed boolean DEFAULT false,
    ai_priority_score numeric DEFAULT 0.0,
    sent_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.communications OWNER TO vikasalagarsamy;

--
-- Name: communications_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.communications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.communications_id_seq OWNER TO vikasalagarsamy;

--
-- Name: communications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.communications_id_seq OWNED BY public.communications.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    registration_number character varying(100),
    tax_id character varying(100),
    address text,
    phone character varying(50),
    email character varying(255),
    website character varying(255),
    founded_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    company_code character varying(20)
);


ALTER TABLE public.companies OWNER TO vikasalagarsamy;

--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.companies_id_seq OWNER TO vikasalagarsamy;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: company_partners; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.company_partners (
    company_id integer NOT NULL,
    partner_id integer NOT NULL,
    contract_details text,
    contract_start_date date,
    contract_end_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.company_partners OWNER TO vikasalagarsamy;

--
-- Name: conversation_sessions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.conversation_sessions (
    id integer NOT NULL,
    quotation_id integer,
    client_phone character varying(20) NOT NULL,
    session_start timestamp without time zone NOT NULL,
    session_end timestamp without time zone,
    message_count integer DEFAULT 0,
    overall_sentiment character varying(20),
    business_outcome character varying(30),
    ai_summary text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.conversation_sessions OWNER TO vikasalagarsamy;

--
-- Name: conversation_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.conversation_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversation_sessions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: conversation_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.conversation_sessions_id_seq OWNED BY public.conversation_sessions.id;


--
-- Name: deliverable_master; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.deliverable_master (
    id bigint NOT NULL,
    category text NOT NULL,
    type text NOT NULL,
    deliverable_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.deliverable_master OWNER TO vikasalagarsamy;

--
-- Name: deliverable_master_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.deliverable_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deliverable_master_id_seq OWNER TO vikasalagarsamy;

--
-- Name: deliverable_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.deliverable_master_id_seq OWNED BY public.deliverable_master.id;


--
-- Name: deliverables; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.deliverables (
    id integer NOT NULL,
    deliverable_cat character varying(50) NOT NULL,
    deliverable_type character varying(50) NOT NULL,
    deliverable_id integer,
    deliverable_name character varying(255) NOT NULL,
    process_name character varying(255) NOT NULL,
    has_customer boolean DEFAULT false,
    has_employee boolean DEFAULT false,
    has_qc boolean DEFAULT false,
    has_vendor boolean DEFAULT false,
    link character varying(255),
    sort_order integer DEFAULT 0,
    timing_type character varying(20) DEFAULT 'days'::character varying,
    tat integer,
    tat_value integer,
    buffer integer,
    skippable boolean DEFAULT false,
    employee jsonb,
    has_download_option boolean DEFAULT false,
    has_task_process boolean DEFAULT true,
    has_upload_folder_path boolean DEFAULT false,
    process_starts_from integer DEFAULT 0,
    status integer DEFAULT 1,
    on_start_template character varying(255),
    on_complete_template character varying(255),
    on_correction_template character varying(255),
    input_names jsonb,
    created_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    stream character varying(10),
    stage character varying(10),
    package_included jsonb DEFAULT '{"basic": false, "elite": false, "premium": false}'::jsonb,
    basic_price numeric,
    elite_price numeric,
    premium_price numeric
);


ALTER TABLE public.deliverables OWNER TO vikasalagarsamy;

--
-- Name: deliverables_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.deliverables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deliverables_id_seq OWNER TO vikasalagarsamy;

--
-- Name: deliverables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.deliverables_id_seq OWNED BY public.deliverables.id;


--
-- Name: department_instructions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.department_instructions (
    id integer NOT NULL,
    quotation_id integer,
    payment_id integer,
    instructions jsonb NOT NULL,
    status character varying(20) DEFAULT 'pending_approval'::character varying,
    created_by character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.department_instructions OWNER TO vikasalagarsamy;

--
-- Name: department_instructions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.department_instructions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.department_instructions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: department_instructions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.department_instructions_id_seq OWNED BY public.department_instructions.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    manager_id integer,
    parent_department_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.departments OWNER TO vikasalagarsamy;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departments_id_seq OWNER TO vikasalagarsamy;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: designation_menu_permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.designation_menu_permissions (
    id integer NOT NULL,
    designation_id integer NOT NULL,
    menu_item_id integer NOT NULL,
    can_view boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(20),
    updated_by character varying(20)
);


ALTER TABLE public.designation_menu_permissions OWNER TO vikasalagarsamy;

--
-- Name: designation_menu_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.designation_menu_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.designation_menu_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: designation_menu_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.designation_menu_permissions_id_seq OWNED BY public.designation_menu_permissions.id;


--
-- Name: designations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.designations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    department_id integer,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.designations OWNER TO vikasalagarsamy;

--
-- Name: designations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.designations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.designations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: designations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.designations_id_seq OWNED BY public.designations.id;


--
-- Name: dynamic_menus; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.dynamic_menus (
    id integer NOT NULL,
    menu_id character varying(100) NOT NULL,
    label character varying(255) NOT NULL,
    href character varying(500) NOT NULL,
    icon character varying(100),
    description text,
    parent_id integer,
    sort_order integer DEFAULT 999,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dynamic_menus OWNER TO vikasalagarsamy;

--
-- Name: dynamic_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.dynamic_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dynamic_menus_id_seq OWNER TO vikasalagarsamy;

--
-- Name: dynamic_menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.dynamic_menus_id_seq OWNED BY public.dynamic_menus.id;


--
-- Name: email_notification_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.email_notification_templates (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    name text NOT NULL,
    subject text NOT NULL,
    html_template text NOT NULL,
    text_template text NOT NULL,
    variables text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.email_notification_templates OWNER TO vikasalagarsamy;

--
-- Name: employee_companies; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.employee_companies (
    id integer NOT NULL,
    employee_id integer,
    company_id integer,
    branch_id integer,
    allocation_percentage integer NOT NULL,
    is_primary boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    start_date date,
    end_date date,
    project_id uuid,
    status text DEFAULT 'active'::text
);


ALTER TABLE public.employee_companies OWNER TO vikasalagarsamy;

--
-- Name: employee_companies_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.employee_companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_companies_id_seq OWNER TO vikasalagarsamy;

--
-- Name: employee_companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.employee_companies_id_seq OWNED BY public.employee_companies.id;


--
-- Name: employee_devices; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.employee_devices (
    id integer NOT NULL,
    employee_id character varying(20) NOT NULL,
    device_id character varying(255) NOT NULL,
    fcm_token text,
    device_name character varying(255),
    platform character varying(50) DEFAULT 'android'::character varying,
    app_version character varying(50),
    is_active boolean DEFAULT true,
    last_seen timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.employee_devices OWNER TO vikasalagarsamy;

--
-- Name: employee_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.employee_devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_devices_id_seq OWNER TO vikasalagarsamy;

--
-- Name: employee_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.employee_devices_id_seq OWNED BY public.employee_devices.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    employee_id character varying(20) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255),
    phone character varying(20),
    address text,
    city character varying(100),
    state character varying(100),
    zip_code character varying(20),
    country character varying(100),
    hire_date date,
    termination_date date,
    status character varying(20) DEFAULT 'active'::character varying,
    department_id integer,
    designation_id integer,
    job_title character varying(100),
    home_branch_id integer,
    primary_company_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name character varying(255),
    username character varying(255),
    password_hash text,
    role_id integer,
    last_login timestamp without time zone,
    is_active boolean DEFAULT true
);


ALTER TABLE public.employees OWNER TO vikasalagarsamy;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_id_seq OWNER TO vikasalagarsamy;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_id character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.events OWNER TO vikasalagarsamy;

--
-- Name: instagram_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_analytics (
    id integer NOT NULL,
    date date NOT NULL,
    total_messages integer DEFAULT 0,
    total_comments integer DEFAULT 0,
    total_mentions integer DEFAULT 0,
    total_story_mentions integer DEFAULT 0,
    new_leads_created integer DEFAULT 0,
    engagement_rate numeric DEFAULT 0.00,
    response_time_minutes integer DEFAULT 0,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_analytics OWNER TO vikasalagarsamy;

--
-- Name: instagram_analytics_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_analytics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_analytics_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_analytics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_analytics_id_seq OWNED BY public.instagram_analytics.id;


--
-- Name: instagram_comments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_comments (
    id integer NOT NULL,
    comment_id character varying(255) NOT NULL,
    post_id character varying(255),
    from_user_id character varying(255) NOT NULL,
    from_username character varying(255),
    comment_text text,
    parent_comment_id character varying(255),
    is_from_client boolean DEFAULT true,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_comments OWNER TO vikasalagarsamy;

--
-- Name: instagram_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_comments_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_comments_id_seq OWNED BY public.instagram_comments.id;


--
-- Name: instagram_interactions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_interactions (
    id integer NOT NULL,
    interaction_type character varying(50) NOT NULL,
    user_id character varying(255) NOT NULL,
    target_message_id character varying(255),
    content character varying(255),
    metadata jsonb DEFAULT '{}'::jsonb,
    "timestamp" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_interactions OWNER TO vikasalagarsamy;

--
-- Name: instagram_interactions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_interactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_interactions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_interactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_interactions_id_seq OWNED BY public.instagram_interactions.id;


--
-- Name: instagram_mentions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_mentions (
    id integer NOT NULL,
    mention_id character varying(255) NOT NULL,
    from_user_id character varying(255) NOT NULL,
    from_username character varying(255),
    mention_text text,
    media_id character varying(255),
    permalink character varying(500),
    mention_type character varying(50) DEFAULT 'tag_mention'::character varying,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_mentions OWNER TO vikasalagarsamy;

--
-- Name: instagram_mentions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_mentions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_mentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_mentions_id_seq OWNED BY public.instagram_mentions.id;


--
-- Name: instagram_messages; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_messages (
    id integer NOT NULL,
    message_id character varying(255) NOT NULL,
    from_user_id character varying(255) NOT NULL,
    to_user_id character varying(255) NOT NULL,
    content text,
    message_type character varying(50) DEFAULT 'text'::character varying,
    attachment_metadata jsonb DEFAULT '{}'::jsonb,
    is_from_client boolean DEFAULT true,
    "timestamp" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_messages OWNER TO vikasalagarsamy;

--
-- Name: instagram_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_messages_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_messages_id_seq OWNED BY public.instagram_messages.id;


--
-- Name: instagram_story_mentions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_story_mentions (
    id integer NOT NULL,
    mention_id character varying(255) NOT NULL,
    from_user_id character varying(255) NOT NULL,
    from_username character varying(255),
    story_text text,
    media_id character varying(255),
    story_url character varying(500),
    metadata jsonb DEFAULT '{}'::jsonb,
    "timestamp" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_story_mentions OWNER TO vikasalagarsamy;

--
-- Name: instagram_story_mentions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_story_mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_story_mentions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_story_mentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_story_mentions_id_seq OWNED BY public.instagram_story_mentions.id;


--
-- Name: instruction_approvals; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instruction_approvals (
    id integer NOT NULL,
    instruction_id integer,
    approval_status character varying(20) NOT NULL,
    approved_by character varying(255),
    approved_at timestamp with time zone,
    comments text,
    submitted_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instruction_approvals OWNER TO vikasalagarsamy;

--
-- Name: instruction_approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instruction_approvals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instruction_approvals_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instruction_approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instruction_approvals_id_seq OWNED BY public.instruction_approvals.id;


--
-- Name: lead_drafts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_drafts (
    id bigint NOT NULL,
    phone text NOT NULL,
    data jsonb NOT NULL,
    status text DEFAULT 'draft'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.lead_drafts OWNER TO vikasalagarsamy;

--
-- Name: lead_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_drafts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_drafts_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_drafts_id_seq OWNED BY public.lead_drafts.id;


--
-- Name: lead_followups; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_followups (
    id integer NOT NULL,
    lead_id integer NOT NULL,
    scheduled_at timestamp with time zone NOT NULL,
    completed_at timestamp with time zone,
    contact_method character varying(50) NOT NULL,
    interaction_summary text,
    status character varying(20) DEFAULT 'scheduled'::character varying NOT NULL,
    outcome text,
    notes text,
    priority character varying(10) DEFAULT 'medium'::character varying,
    created_by text,
    created_at timestamp with time zone DEFAULT now(),
    updated_by uuid,
    updated_at timestamp with time zone,
    completed_by uuid,
    duration_minutes integer,
    follow_up_required boolean DEFAULT false,
    next_follow_up_date timestamp with time zone,
    followup_type text,
    workflow_stage character varying(50),
    quotation_id integer
);


ALTER TABLE public.lead_followups OWNER TO vikasalagarsamy;

--
-- Name: lead_followups_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_followups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_followups_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_followups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_followups_id_seq OWNED BY public.lead_followups.id;


--
-- Name: lead_sources; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_sources (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.lead_sources OWNER TO vikasalagarsamy;

--
-- Name: lead_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_sources_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_sources_id_seq OWNED BY public.lead_sources.id;


--
-- Name: lead_task_performance; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_task_performance (
    id integer NOT NULL,
    lead_id integer NOT NULL,
    task_id integer NOT NULL,
    response_time_hours numeric,
    completion_time_hours numeric,
    sla_met boolean,
    revenue_impact numeric,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.lead_task_performance OWNER TO vikasalagarsamy;

--
-- Name: lead_task_performance_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_task_performance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_task_performance_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_task_performance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_task_performance_id_seq OWNED BY public.lead_task_performance.id;


--
-- Name: leads; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.leads (
    id integer NOT NULL,
    lead_number character varying(20) NOT NULL,
    company_id integer NOT NULL,
    branch_id integer,
    client_name character varying(255) NOT NULL,
    email character varying(255),
    country_code character varying(10),
    phone character varying(20),
    is_whatsapp boolean DEFAULT false,
    has_separate_whatsapp boolean DEFAULT false,
    whatsapp_country_code character varying(10),
    whatsapp_number character varying(20),
    notes text,
    status character varying(50) DEFAULT 'UNASSIGNED'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    assigned_to integer,
    lead_source character varying(100),
    location character varying(255),
    lead_source_id integer,
    rejection_reason text,
    rejected_at timestamp with time zone,
    rejected_by uuid,
    rejected_by_employee_id character varying(50),
    assigned_to_uuid uuid,
    previous_assigned_to integer,
    reassignment_date timestamp with time zone,
    reassignment_reason character varying(50),
    is_reassigned boolean DEFAULT false,
    reassigned_at timestamp with time zone,
    reassigned_by integer,
    reassigned_from_company_id integer,
    reassigned_from_branch_id integer,
    bride_name text,
    groom_name text,
    priority character varying(20) DEFAULT 'medium'::character varying,
    expected_value numeric DEFAULT 0,
    last_contact_date timestamp without time zone,
    next_follow_up_date timestamp without time zone,
    conversion_stage character varying(50) DEFAULT 'new'::character varying,
    lead_score integer DEFAULT 50,
    tags text[],
    budget_range character varying(50),
    wedding_date date,
    venue_preference text,
    guest_count integer,
    description text,
    rejection_date timestamp without time zone
);


ALTER TABLE public.leads OWNER TO vikasalagarsamy;

--
-- Name: leads_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.leads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.leads_id_seq OWNER TO vikasalagarsamy;

--
-- Name: leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.leads_id_seq OWNED BY public.leads.id;


--
-- Name: management_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.management_insights (
    id integer NOT NULL,
    insight_type text NOT NULL,
    employee_id text,
    priority text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    key_metrics jsonb DEFAULT '{}'::jsonb NOT NULL,
    suggested_questions jsonb DEFAULT '[]'::jsonb NOT NULL,
    recommended_actions jsonb DEFAULT '[]'::jsonb NOT NULL,
    confidence_score numeric NOT NULL,
    is_addressed boolean DEFAULT false NOT NULL,
    addressed_at timestamp with time zone,
    addressed_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone
);


ALTER TABLE public.management_insights OWNER TO vikasalagarsamy;

--
-- Name: management_insights_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.management_insights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.management_insights_id_seq OWNER TO vikasalagarsamy;

--
-- Name: management_insights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.management_insights_id_seq OWNED BY public.management_insights.id;


--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.menu_items (
    id integer NOT NULL,
    parent_id integer,
    name character varying(100) NOT NULL,
    description text,
    icon character varying(50),
    path character varying(255),
    sort_order integer DEFAULT 0,
    is_visible boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    string_id character varying(100),
    section_name character varying(100),
    is_admin_only boolean DEFAULT false,
    badge_text character varying(50),
    badge_variant character varying(20) DEFAULT 'secondary'::character varying,
    is_new boolean DEFAULT false,
    category character varying(20) DEFAULT 'primary'::character varying
);


ALTER TABLE public.menu_items OWNER TO vikasalagarsamy;

--
-- Name: menu_items_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.menu_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_items_id_seq OWNER TO vikasalagarsamy;

--
-- Name: menu_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.menu_items_id_seq OWNED BY public.menu_items.id;


--
-- Name: menu_items_tracking; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.menu_items_tracking (
    id integer NOT NULL,
    menu_item_id integer NOT NULL,
    last_known_state jsonb NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.menu_items_tracking OWNER TO vikasalagarsamy;

--
-- Name: menu_items_tracking_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.menu_items_tracking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_items_tracking_id_seq OWNER TO vikasalagarsamy;

--
-- Name: menu_items_tracking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.menu_items_tracking_id_seq OWNED BY public.menu_items_tracking.id;


--
-- Name: message_analysis; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.message_analysis (
    id integer NOT NULL,
    message_id integer,
    sentiment character varying(20),
    sentiment_score numeric,
    intent character varying(50),
    urgency_level integer,
    key_topics text[],
    recommended_action text,
    confidence_score numeric,
    ai_model_version character varying(20) DEFAULT 'gpt-4'::character varying,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.message_analysis OWNER TO vikasalagarsamy;

--
-- Name: message_analysis_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.message_analysis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_analysis_id_seq OWNER TO vikasalagarsamy;

--
-- Name: message_analysis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.message_analysis_id_seq OWNED BY public.message_analysis.id;


--
-- Name: ml_model_performance; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ml_model_performance (
    id integer NOT NULL,
    model_name text NOT NULL,
    model_version text NOT NULL,
    metric_type text NOT NULL,
    metric_value numeric NOT NULL,
    dataset_size integer NOT NULL,
    training_date timestamp with time zone NOT NULL,
    evaluation_date timestamp with time zone DEFAULT now() NOT NULL,
    is_production_model boolean DEFAULT false NOT NULL
);


ALTER TABLE public.ml_model_performance OWNER TO vikasalagarsamy;

--
-- Name: ml_model_performance_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ml_model_performance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ml_model_performance_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ml_model_performance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ml_model_performance_id_seq OWNED BY public.ml_model_performance.id;


--
-- Name: notification_batches; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_batches (
    id integer NOT NULL,
    user_id integer NOT NULL,
    notification_type character varying(100) NOT NULL,
    batch_key character varying(200) NOT NULL,
    last_sent timestamp with time zone DEFAULT now(),
    count integer DEFAULT 1,
    metadata jsonb
);


ALTER TABLE public.notification_batches OWNER TO vikasalagarsamy;

--
-- Name: notification_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.notification_batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_batches_id_seq OWNER TO vikasalagarsamy;

--
-- Name: notification_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.notification_batches_id_seq OWNED BY public.notification_batches.id;


--
-- Name: notification_engagement; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_engagement (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id text NOT NULL,
    user_id uuid NOT NULL,
    event_type text NOT NULL,
    engagement_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.notification_engagement OWNER TO vikasalagarsamy;

--
-- Name: notification_patterns; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_patterns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type text NOT NULL,
    frequency integer DEFAULT 1,
    engagement_rate numeric DEFAULT 0.5,
    optimal_timing integer[] DEFAULT ARRAY[9, 14, 16],
    user_segments text[] DEFAULT ARRAY['general'::text],
    success_metrics jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.notification_patterns OWNER TO vikasalagarsamy;

--
-- Name: notification_preferences; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_preferences (
    user_id uuid NOT NULL,
    email_notifications boolean DEFAULT true,
    push_notifications boolean DEFAULT true,
    permission_changes boolean DEFAULT true,
    role_assignments boolean DEFAULT true,
    admin_role_changes boolean DEFAULT true,
    security_permission_changes boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notification_preferences OWNER TO vikasalagarsamy;

--
-- Name: notification_recipients; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_recipients (
    notification_id integer NOT NULL,
    user_id uuid NOT NULL,
    is_read boolean DEFAULT false,
    is_dismissed boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notification_recipients OWNER TO vikasalagarsamy;

--
-- Name: notification_rules; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_rules (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    name text NOT NULL,
    trigger_type text NOT NULL,
    conditions jsonb DEFAULT '{}'::jsonb NOT NULL,
    recipients text[] DEFAULT '{}'::text[] NOT NULL,
    template_id text,
    enabled boolean DEFAULT true NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notification_rules OWNER TO vikasalagarsamy;

--
-- Name: notification_settings; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_settings (
    user_id integer NOT NULL,
    email_enabled boolean DEFAULT true NOT NULL,
    in_app_enabled boolean DEFAULT true NOT NULL,
    overdue_alerts boolean DEFAULT true NOT NULL,
    approval_alerts boolean DEFAULT true NOT NULL,
    payment_alerts boolean DEFAULT true NOT NULL,
    automation_alerts boolean DEFAULT true NOT NULL,
    email_frequency text DEFAULT 'immediate'::text NOT NULL,
    quiet_hours_start time without time zone,
    quiet_hours_end time without time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notification_settings OWNER TO vikasalagarsamy;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notifications (
    id text NOT NULL,
    type text NOT NULL,
    priority text DEFAULT 'medium'::text NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    quotation_id integer,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    action_url text,
    action_label text,
    metadata jsonb,
    scheduled_for timestamp with time zone DEFAULT now(),
    ai_enhanced boolean DEFAULT false,
    recipient_role character varying(50),
    recipient_id integer,
    data jsonb,
    read_at timestamp with time zone,
    target_user uuid,
    employee_id integer
);


ALTER TABLE public.notifications OWNER TO vikasalagarsamy;

--
-- Name: partners; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.partners (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    contact_person character varying(200),
    email character varying(255),
    phone character varying(50),
    address text,
    partnership_type character varying(100),
    partnership_start_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.partners OWNER TO vikasalagarsamy;

--
-- Name: partners_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.partners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partners_id_seq OWNER TO vikasalagarsamy;

--
-- Name: partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.partners_id_seq OWNED BY public.partners.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    quotation_id integer,
    amount numeric NOT NULL,
    payment_type character varying(20) NOT NULL,
    payment_method character varying(50) NOT NULL,
    payment_reference character varying(100) NOT NULL,
    paid_by character varying(255) NOT NULL,
    status character varying(20) DEFAULT 'received'::character varying,
    received_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.payments OWNER TO vikasalagarsamy;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO vikasalagarsamy;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    category character varying(100) NOT NULL,
    resource character varying(100),
    action character varying(100),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(50) DEFAULT 'active'::character varying
);


ALTER TABLE public.permissions OWNER TO vikasalagarsamy;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: personalization_learning; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.personalization_learning (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    interaction_type text NOT NULL,
    interaction_data jsonb NOT NULL,
    outcome_positive boolean,
    learning_weight numeric DEFAULT 1.0,
    context_tags text[] DEFAULT '{}'::text[],
    session_id text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.personalization_learning OWNER TO vikasalagarsamy;

--
-- Name: post_sale_confirmations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.post_sale_confirmations (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    confirmed_by_user_id uuid NOT NULL,
    confirmation_date timestamp without time zone DEFAULT now() NOT NULL,
    call_date date NOT NULL,
    call_time time without time zone NOT NULL,
    call_duration integer DEFAULT 30 NOT NULL,
    client_contact_person character varying(255) NOT NULL,
    confirmation_method character varying(50) DEFAULT 'phone'::character varying NOT NULL,
    services_confirmed jsonb DEFAULT '[]'::jsonb,
    deliverables_confirmed jsonb DEFAULT '[]'::jsonb,
    event_details_confirmed jsonb DEFAULT '{}'::jsonb,
    client_satisfaction_rating integer DEFAULT 5,
    client_expectations text NOT NULL,
    client_concerns text,
    additional_requests text,
    call_summary text NOT NULL,
    action_items text,
    follow_up_required boolean DEFAULT false,
    follow_up_date date,
    attachments jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.post_sale_confirmations OWNER TO vikasalagarsamy;

--
-- Name: post_sale_confirmations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.post_sale_confirmations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_sale_confirmations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: post_sale_confirmations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.post_sale_confirmations_id_seq OWNED BY public.post_sale_confirmations.id;


--
-- Name: post_sales_workflows; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.post_sales_workflows (
    id integer NOT NULL,
    quotation_id integer,
    payment_id integer,
    instruction_id integer,
    client_name character varying(255) NOT NULL,
    status character varying(30) DEFAULT 'pending_confirmation'::character varying,
    instructions jsonb,
    confirmed_by character varying(255),
    confirmed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.post_sales_workflows OWNER TO vikasalagarsamy;

--
-- Name: post_sales_workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.post_sales_workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_sales_workflows_id_seq OWNER TO vikasalagarsamy;

--
-- Name: post_sales_workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.post_sales_workflows_id_seq OWNED BY public.post_sales_workflows.id;


--
-- Name: predictive_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.predictive_insights (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    insight_type text NOT NULL,
    probability numeric NOT NULL,
    recommended_action text NOT NULL,
    trigger_conditions jsonb DEFAULT '{}'::jsonb,
    estimated_impact numeric DEFAULT 0,
    status text DEFAULT 'pending'::text,
    expires_at timestamp with time zone DEFAULT (now() + '7 days'::interval),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.predictive_insights OWNER TO vikasalagarsamy;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    full_name character varying(255),
    avatar_url text,
    job_title character varying(255),
    department character varying(255),
    location character varying(255),
    phone character varying(50),
    bio text,
    employee_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.profiles OWNER TO vikasalagarsamy;

--
-- Name: query_performance_logs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.query_performance_logs (
    id integer NOT NULL,
    view_name text,
    rows_returned integer,
    execution_time_ms double precision,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.query_performance_logs OWNER TO vikasalagarsamy;

--
-- Name: query_performance_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.query_performance_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.query_performance_logs_id_seq OWNER TO vikasalagarsamy;

--
-- Name: query_performance_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.query_performance_logs_id_seq OWNED BY public.query_performance_logs.id;


--
-- Name: quotation_approvals; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_approvals (
    id integer NOT NULL,
    quotation_id integer,
    approval_status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    approval_date timestamp without time zone,
    comments text,
    price_adjustments jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    approver_user_id integer NOT NULL
);


ALTER TABLE public.quotation_approvals OWNER TO vikasalagarsamy;

--
-- Name: quotation_approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_approvals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_approvals_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_approvals_id_seq OWNED BY public.quotation_approvals.id;


--
-- Name: quotation_business_lifecycle; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_business_lifecycle (
    id integer NOT NULL,
    quotation_id integer,
    current_stage character varying(30) DEFAULT 'quotation_sent'::character varying NOT NULL,
    stage_history jsonb[],
    probability_score integer,
    last_client_interaction timestamp without time zone,
    next_follow_up_due timestamp without time zone,
    days_in_pipeline integer DEFAULT 0,
    revision_count integer DEFAULT 0,
    ai_insights text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.quotation_business_lifecycle OWNER TO vikasalagarsamy;

--
-- Name: quotation_business_lifecycle_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_business_lifecycle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_business_lifecycle_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_business_lifecycle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_business_lifecycle_id_seq OWNED BY public.quotation_business_lifecycle.id;


--
-- Name: quotation_edit_approvals; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_edit_approvals (
    id bigint NOT NULL,
    quotation_id bigint NOT NULL,
    requested_by integer NOT NULL,
    approved_by integer,
    original_data jsonb NOT NULL,
    modified_data jsonb NOT NULL,
    changes_summary text,
    edit_reason text,
    original_amount numeric DEFAULT 0,
    modified_amount numeric DEFAULT 0,
    amount_difference numeric DEFAULT 0,
    percentage_change numeric DEFAULT 0,
    approval_status character varying(20) DEFAULT 'pending'::character varying,
    approval_date timestamp with time zone,
    approval_comments text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.quotation_edit_approvals OWNER TO vikasalagarsamy;

--
-- Name: quotation_edit_approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_edit_approvals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_edit_approvals_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_edit_approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_edit_approvals_id_seq OWNED BY public.quotation_edit_approvals.id;


--
-- Name: quotation_events; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_events (
    id integer NOT NULL,
    quotation_id integer,
    event_name character varying(255) NOT NULL,
    event_date timestamp with time zone NOT NULL,
    event_location character varying(255) NOT NULL,
    venue_name character varying(255) NOT NULL,
    start_time character varying(10) NOT NULL,
    end_time character varying(10) NOT NULL,
    expected_crowd character varying(100),
    selected_package character varying(20) NOT NULL,
    selected_services jsonb DEFAULT '[]'::jsonb,
    selected_deliverables jsonb DEFAULT '[]'::jsonb,
    service_overrides jsonb DEFAULT '{}'::jsonb,
    package_overrides jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.quotation_events OWNER TO vikasalagarsamy;

--
-- Name: quotation_events_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_events_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_events_id_seq OWNED BY public.quotation_events.id;


--
-- Name: quotation_predictions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_predictions (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    success_probability numeric NOT NULL,
    confidence_score numeric NOT NULL,
    prediction_factors jsonb DEFAULT '{}'::jsonb NOT NULL,
    model_version text DEFAULT 'v1.0'::text NOT NULL,
    predicted_at timestamp with time zone DEFAULT now() NOT NULL,
    actual_outcome text,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.quotation_predictions OWNER TO vikasalagarsamy;

--
-- Name: quotation_predictions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_predictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_predictions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_predictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_predictions_id_seq OWNED BY public.quotation_predictions.id;


--
-- Name: quotation_revisions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_revisions (
    id integer NOT NULL,
    original_quotation_id integer,
    revision_number integer NOT NULL,
    revised_quotation_data jsonb NOT NULL,
    revision_reason text NOT NULL,
    revised_by character varying(255) NOT NULL,
    status character varying(20) DEFAULT 'pending_approval'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.quotation_revisions OWNER TO vikasalagarsamy;

--
-- Name: quotation_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_revisions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_revisions_id_seq OWNED BY public.quotation_revisions.id;


--
-- Name: quotation_workflow_history; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_workflow_history (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    action character varying(50) NOT NULL,
    performed_at timestamp without time zone DEFAULT now() NOT NULL,
    comments text,
    performed_by integer NOT NULL
);


ALTER TABLE public.quotation_workflow_history OWNER TO vikasalagarsamy;

--
-- Name: quotation_workflow_history_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_workflow_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_workflow_history_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_workflow_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_workflow_history_id_seq OWNED BY public.quotation_workflow_history.id;


--
-- Name: quotations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotations (
    id integer NOT NULL,
    lead_id integer,
    follow_up_id integer,
    quotation_number character varying(50) NOT NULL,
    client_name character varying(255) NOT NULL,
    bride_name character varying(255) NOT NULL,
    groom_name character varying(255) NOT NULL,
    mobile character varying(50) NOT NULL,
    whatsapp character varying(50),
    alternate_mobile character varying(50),
    alternate_whatsapp character varying(50),
    email character varying(255) NOT NULL,
    default_package character varying(20) NOT NULL,
    total_amount numeric NOT NULL,
    status character varying(20) DEFAULT 'draft'::character varying,
    quotation_data jsonb NOT NULL,
    events_count integer DEFAULT 1,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    slug text,
    workflow_status character varying(50) DEFAULT 'draft'::character varying,
    client_verbal_confirmation_date timestamp without time zone,
    payment_received_date timestamp without time zone,
    payment_amount numeric,
    payment_reference character varying(100),
    confirmation_required boolean DEFAULT true,
    created_by integer NOT NULL,
    revision_notes text,
    client_feedback text,
    negotiation_history jsonb DEFAULT '[]'::jsonb,
    revision_count integer DEFAULT 0
);


ALTER TABLE public.quotations OWNER TO vikasalagarsamy;

--
-- Name: quotations_backup_before_migration; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotations_backup_before_migration (
    id integer,
    lead_id integer,
    follow_up_id integer,
    quotation_number character varying(50),
    client_name character varying(255),
    bride_name character varying(255),
    groom_name character varying(255),
    mobile character varying(50),
    whatsapp character varying(50),
    alternate_mobile character varying(50),
    alternate_whatsapp character varying(50),
    email character varying(255),
    default_package character varying(20),
    total_amount numeric,
    status character varying(20),
    created_by uuid,
    quotation_data jsonb,
    events_count integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    slug text,
    workflow_status character varying(50),
    client_verbal_confirmation_date timestamp without time zone,
    payment_received_date timestamp without time zone,
    payment_amount numeric,
    payment_reference character varying(100),
    confirmation_required boolean
);


ALTER TABLE public.quotations_backup_before_migration OWNER TO vikasalagarsamy;

--
-- Name: quotations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotations_id_seq OWNED BY public.quotations.id;


--
-- Name: quote_components; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quote_components (
    id integer NOT NULL,
    quote_id integer NOT NULL,
    component_type character varying(50) NOT NULL,
    component_name character varying(255) NOT NULL,
    component_description text,
    unit_price numeric,
    quantity integer DEFAULT 1,
    subtotal numeric NOT NULL,
    metadata jsonb,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quote_components OWNER TO vikasalagarsamy;

--
-- Name: quote_components_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quote_components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_components_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quote_components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quote_components_id_seq OWNED BY public.quote_components.id;


--
-- Name: quote_deliverables_snapshot; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quote_deliverables_snapshot (
    id integer NOT NULL,
    quote_id integer NOT NULL,
    deliverable_id integer NOT NULL,
    deliverable_name character varying(255) NOT NULL,
    deliverable_type character varying(50) NOT NULL,
    process_name character varying(255) NOT NULL,
    package_type character varying(20) NOT NULL,
    tat integer,
    timing_type character varying(20),
    sort_order integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quote_deliverables_snapshot OWNER TO vikasalagarsamy;

--
-- Name: quote_deliverables_snapshot_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quote_deliverables_snapshot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_deliverables_snapshot_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quote_deliverables_snapshot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quote_deliverables_snapshot_id_seq OWNED BY public.quote_deliverables_snapshot.id;


--
-- Name: quote_services_snapshot; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quote_services_snapshot (
    id integer NOT NULL,
    quote_id integer NOT NULL,
    service_id integer NOT NULL,
    service_name character varying(255) NOT NULL,
    package_type character varying(20) NOT NULL,
    locked_price numeric NOT NULL,
    quantity integer DEFAULT 1,
    subtotal numeric NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quote_services_snapshot OWNER TO vikasalagarsamy;

--
-- Name: quote_services_snapshot_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quote_services_snapshot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_services_snapshot_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quote_services_snapshot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quote_services_snapshot_id_seq OWNED BY public.quote_services_snapshot.id;


--
-- Name: revenue_forecasts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.revenue_forecasts (
    id integer NOT NULL,
    forecast_period text NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    predicted_revenue numeric NOT NULL,
    confidence_interval_low numeric NOT NULL,
    confidence_interval_high numeric NOT NULL,
    contributing_factors jsonb DEFAULT '{}'::jsonb NOT NULL,
    model_metrics jsonb DEFAULT '{}'::jsonb NOT NULL,
    actual_revenue numeric,
    forecast_accuracy numeric,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.revenue_forecasts OWNER TO vikasalagarsamy;

--
-- Name: revenue_forecasts_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.revenue_forecasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.revenue_forecasts_id_seq OWNER TO vikasalagarsamy;

--
-- Name: revenue_forecasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.revenue_forecasts_id_seq OWNED BY public.revenue_forecasts.id;


--
-- Name: role_menu_access; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.role_menu_access (
    id integer NOT NULL,
    role_name character varying(100) NOT NULL,
    menu_id character varying(100) NOT NULL,
    has_access boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.role_menu_access OWNER TO vikasalagarsamy;

--
-- Name: role_menu_access_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.role_menu_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_menu_access_id_seq OWNER TO vikasalagarsamy;

--
-- Name: role_menu_access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.role_menu_access_id_seq OWNED BY public.role_menu_access.id;


--
-- Name: role_menu_permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.role_menu_permissions (
    id integer NOT NULL,
    role_id integer NOT NULL,
    can_view boolean DEFAULT false,
    can_add boolean DEFAULT false,
    can_edit boolean DEFAULT false,
    can_delete boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    description text,
    menu_string_id character varying(100) NOT NULL
);


ALTER TABLE public.role_menu_permissions OWNER TO vikasalagarsamy;

--
-- Name: role_menu_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.role_menu_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_menu_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: role_menu_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.role_menu_permissions_id_seq OWNED BY public.role_menu_permissions.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.role_permissions (
    id integer NOT NULL,
    role_id integer,
    permission_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(50) DEFAULT 'active'::character varying
);


ALTER TABLE public.role_permissions OWNER TO vikasalagarsamy;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.role_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    title character varying(255),
    description text,
    department_id integer,
    responsibilities text[],
    required_skills text[],
    is_management boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_system_role boolean DEFAULT false,
    is_admin boolean DEFAULT false,
    name text DEFAULT 'Unnamed Role'::text NOT NULL,
    permissions jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.roles OWNER TO vikasalagarsamy;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO vikasalagarsamy;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: sales_activities; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sales_activities (
    id integer NOT NULL,
    employee_id text NOT NULL,
    quotation_id integer,
    activity_type text NOT NULL,
    activity_description text NOT NULL,
    activity_outcome text,
    time_spent_minutes integer DEFAULT 0,
    activity_date timestamp with time zone DEFAULT now() NOT NULL,
    notes text,
    client_name text,
    deal_value numeric,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sales_activities OWNER TO vikasalagarsamy;

--
-- Name: sales_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sales_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_activities_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sales_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sales_activities_id_seq OWNED BY public.sales_activities.id;


--
-- Name: sales_performance_metrics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sales_performance_metrics (
    id integer NOT NULL,
    employee_id text NOT NULL,
    metric_period date NOT NULL,
    quotations_created integer DEFAULT 0 NOT NULL,
    quotations_converted integer DEFAULT 0 NOT NULL,
    total_revenue_generated numeric DEFAULT 0 NOT NULL,
    avg_deal_size numeric DEFAULT 0 NOT NULL,
    avg_conversion_time_days integer DEFAULT 0 NOT NULL,
    follow_ups_completed integer DEFAULT 0 NOT NULL,
    client_meetings_held integer DEFAULT 0 NOT NULL,
    calls_made integer DEFAULT 0 NOT NULL,
    emails_sent integer DEFAULT 0 NOT NULL,
    conversion_rate numeric DEFAULT 0 NOT NULL,
    activity_score numeric DEFAULT 0 NOT NULL,
    performance_score numeric DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sales_performance_metrics OWNER TO vikasalagarsamy;

--
-- Name: sales_performance_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sales_performance_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_performance_metrics_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sales_performance_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sales_performance_metrics_id_seq OWNED BY public.sales_performance_metrics.id;


--
-- Name: sales_team_members; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sales_team_members (
    id integer NOT NULL,
    employee_id text NOT NULL,
    full_name text NOT NULL,
    email text NOT NULL,
    phone text,
    role text NOT NULL,
    hire_date date NOT NULL,
    territory text,
    target_monthly numeric DEFAULT 0,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sales_team_members OWNER TO vikasalagarsamy;

--
-- Name: sales_team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sales_team_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_team_members_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sales_team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sales_team_members_id_seq OWNED BY public.sales_team_members.id;


--
-- Name: sequence_rules; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sequence_rules (
    id integer NOT NULL,
    sequence_template_id integer,
    rule_type character varying(100) NOT NULL,
    condition_field character varying(100) NOT NULL,
    condition_operator character varying(20) NOT NULL,
    condition_value text NOT NULL,
    action_type character varying(100) NOT NULL,
    action_data jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sequence_rules OWNER TO vikasalagarsamy;

--
-- Name: sequence_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sequence_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sequence_rules_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sequence_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sequence_rules_id_seq OWNED BY public.sequence_rules.id;


--
-- Name: sequence_steps; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sequence_steps (
    id integer NOT NULL,
    sequence_template_id integer,
    step_number integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    icon character varying(50) DEFAULT 'target'::character varying,
    due_after_hours integer DEFAULT 24,
    priority character varying(20) DEFAULT 'medium'::character varying,
    is_conditional boolean DEFAULT false,
    condition_type character varying(100),
    condition_value text,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sequence_steps OWNER TO vikasalagarsamy;

--
-- Name: sequence_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sequence_steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sequence_steps_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sequence_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sequence_steps_id_seq OWNED BY public.sequence_steps.id;


--
-- Name: service_packages; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.service_packages (
    id integer NOT NULL,
    package_name character varying(50) NOT NULL,
    package_display_name character varying(100) NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.service_packages OWNER TO vikasalagarsamy;

--
-- Name: service_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.service_packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_packages_id_seq OWNER TO vikasalagarsamy;

--
-- Name: service_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.service_packages_id_seq OWNED BY public.service_packages.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.services (
    id integer NOT NULL,
    servicename character varying(255) NOT NULL,
    status character varying(50) DEFAULT 'Active'::character varying NOT NULL,
    description text,
    category character varying(100),
    price numeric,
    unit character varying(50),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    basic_price numeric,
    premium_price numeric,
    elite_price numeric,
    package_included jsonb DEFAULT '{"basic": false, "elite": false, "premium": false}'::jsonb
);


ALTER TABLE public.services OWNER TO vikasalagarsamy;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.services_id_seq OWNER TO vikasalagarsamy;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.suppliers (
    id integer NOT NULL,
    supplier_code character varying(20) NOT NULL,
    name character varying(100) NOT NULL,
    contact_person character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20) NOT NULL,
    address text NOT NULL,
    city character varying(50) NOT NULL,
    state character varying(50) NOT NULL,
    postal_code character varying(20) NOT NULL,
    country character varying(50) NOT NULL,
    category character varying(50) NOT NULL,
    tax_id character varying(50),
    payment_terms character varying(100),
    website character varying(255),
    notes text,
    status character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    lead_time character varying(100)
);


ALTER TABLE public.suppliers OWNER TO vikasalagarsamy;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suppliers_id_seq OWNER TO vikasalagarsamy;

--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- Name: system_logs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.system_logs (
    id integer NOT NULL,
    action character varying(100) NOT NULL,
    details jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.system_logs OWNER TO vikasalagarsamy;

--
-- Name: system_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.system_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.system_logs_id_seq OWNER TO vikasalagarsamy;

--
-- Name: system_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.system_logs_id_seq OWNED BY public.system_logs.id;


--
-- Name: task_generation_log; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_generation_log (
    id integer NOT NULL,
    lead_id integer,
    quotation_id integer,
    rule_triggered character varying(100) NOT NULL,
    task_id integer,
    success boolean NOT NULL,
    error_message text,
    triggered_by character varying(100),
    triggered_at timestamp with time zone DEFAULT now(),
    metadata jsonb
);


ALTER TABLE public.task_generation_log OWNER TO vikasalagarsamy;

--
-- Name: task_generation_log_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_generation_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_generation_log_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_generation_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_generation_log_id_seq OWNED BY public.task_generation_log.id;


--
-- Name: task_performance_metrics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_performance_metrics (
    id integer NOT NULL,
    task_id integer NOT NULL,
    lead_id integer,
    quotation_id integer,
    assigned_to integer,
    created_date date NOT NULL,
    due_date date,
    completed_date date,
    days_to_complete integer,
    hours_estimated numeric,
    hours_actual numeric,
    efficiency_ratio numeric,
    priority_level character varying(20),
    was_overdue boolean DEFAULT false,
    quality_rating integer,
    revenue_impact numeric,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.task_performance_metrics OWNER TO vikasalagarsamy;

--
-- Name: task_performance_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_performance_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_performance_metrics_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_performance_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_performance_metrics_id_seq OWNED BY public.task_performance_metrics.id;


--
-- Name: task_sequence_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_sequence_templates (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    category character varying(100) DEFAULT 'sales_followup'::character varying,
    is_active boolean DEFAULT true,
    created_by character varying(100) DEFAULT 'Admin'::character varying,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.task_sequence_templates OWNER TO vikasalagarsamy;

--
-- Name: task_sequence_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_sequence_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_sequence_templates_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_sequence_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_sequence_templates_id_seq OWNED BY public.task_sequence_templates.id;


--
-- Name: task_status_history; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_status_history (
    id integer NOT NULL,
    task_id integer NOT NULL,
    from_status character varying(20),
    to_status character varying(20) NOT NULL,
    changed_at timestamp with time zone DEFAULT now(),
    changed_by character varying(100),
    notes text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.task_status_history OWNER TO vikasalagarsamy;

--
-- Name: task_status_history_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_status_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_status_history_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_status_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_status_history_id_seq OWNED BY public.task_status_history.id;


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.team_members (
    team_id integer NOT NULL,
    employee_id integer NOT NULL,
    joined_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.team_members OWNER TO vikasalagarsamy;

--
-- Name: team_performance_trends; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.team_performance_trends (
    id integer NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    total_quotations integer DEFAULT 0 NOT NULL,
    total_conversions integer DEFAULT 0 NOT NULL,
    total_revenue numeric DEFAULT 0 NOT NULL,
    team_conversion_rate numeric DEFAULT 0 NOT NULL,
    avg_deal_size numeric DEFAULT 0 NOT NULL,
    avg_sales_cycle_days integer DEFAULT 0 NOT NULL,
    top_performer_id text,
    underperformer_id text,
    performance_variance numeric DEFAULT 0 NOT NULL,
    team_activity_score numeric DEFAULT 0 NOT NULL,
    coaching_opportunities integer DEFAULT 0 NOT NULL,
    process_improvements_needed integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.team_performance_trends OWNER TO vikasalagarsamy;

--
-- Name: team_performance_trends_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.team_performance_trends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_performance_trends_id_seq OWNER TO vikasalagarsamy;

--
-- Name: team_performance_trends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.team_performance_trends_id_seq OWNED BY public.team_performance_trends.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    department_id integer,
    team_lead_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.teams OWNER TO vikasalagarsamy;

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_id_seq OWNER TO vikasalagarsamy;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: unified_role_permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.unified_role_permissions (
    id integer NOT NULL,
    role_id integer NOT NULL,
    menu_string_id character varying(100) NOT NULL,
    can_view boolean DEFAULT false,
    can_add boolean DEFAULT false,
    can_edit boolean DEFAULT false,
    can_delete boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.unified_role_permissions OWNER TO vikasalagarsamy;

--
-- Name: unified_role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.unified_role_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unified_role_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: unified_role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.unified_role_permissions_id_seq OWNED BY public.unified_role_permissions.id;


--
-- Name: user_accounts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_accounts (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    role_id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    is_active boolean DEFAULT true,
    last_login timestamp without time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_accounts OWNER TO vikasalagarsamy;

--
-- Name: user_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.user_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_accounts_id_seq OWNER TO vikasalagarsamy;

--
-- Name: user_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.user_accounts_id_seq OWNED BY public.user_accounts.id;


--
-- Name: user_activity_history; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_activity_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    activity_type text NOT NULL,
    activity_data jsonb DEFAULT '{}'::jsonb,
    session_id text,
    ip_address inet,
    user_agent text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_activity_history OWNER TO vikasalagarsamy;

--
-- Name: user_ai_profiles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_ai_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    personality_type text DEFAULT 'balanced'::text,
    communication_style text DEFAULT 'formal'::text,
    preferred_content_length text DEFAULT 'medium'::text,
    engagement_patterns jsonb DEFAULT '{}'::jsonb,
    response_time_patterns jsonb DEFAULT '{}'::jsonb,
    content_preferences jsonb DEFAULT '{}'::jsonb,
    ai_learning_enabled boolean DEFAULT true,
    personalization_score numeric DEFAULT 0.5,
    last_interaction timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_ai_profiles OWNER TO vikasalagarsamy;

--
-- Name: user_behavior_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_behavior_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    most_active_hours integer[] DEFAULT ARRAY[9, 10, 14, 15, 16],
    avg_response_time integer DEFAULT 1800,
    preferred_notification_types text[] DEFAULT ARRAY['system'::text],
    engagement_score numeric DEFAULT 0.5,
    timezone text DEFAULT 'UTC'::text,
    device_types text[] DEFAULT ARRAY['web'::text],
    last_activity timestamp with time zone DEFAULT now(),
    total_notifications_received integer DEFAULT 0,
    total_notifications_read integer DEFAULT 0,
    average_read_time integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_behavior_analytics OWNER TO vikasalagarsamy;

--
-- Name: user_engagement_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_engagement_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    notification_id text,
    engagement_type text NOT NULL,
    engagement_value numeric DEFAULT 1.0,
    channel text NOT NULL,
    device_type text,
    time_to_engage integer,
    context_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_engagement_analytics OWNER TO vikasalagarsamy;

--
-- Name: user_id_mapping; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_id_mapping (
    numeric_id integer NOT NULL,
    uuid uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_id_mapping OWNER TO vikasalagarsamy;

--
-- Name: user_preferences; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name text,
    include_name boolean DEFAULT false,
    channel_preferences text[] DEFAULT ARRAY['in_app'::text],
    quiet_hours_start integer DEFAULT 22,
    quiet_hours_end integer DEFAULT 8,
    frequency_limit integer DEFAULT 10,
    ai_optimization_enabled boolean DEFAULT true,
    personalization_level text DEFAULT 'medium'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_preferences OWNER TO vikasalagarsamy;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_roles (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_roles OWNER TO vikasalagarsamy;

--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_roles_id_seq OWNER TO vikasalagarsamy;

--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    employee_id character varying(50)
);


ALTER TABLE public.users OWNER TO vikasalagarsamy;

--
-- Name: vendors; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.vendors (
    id integer NOT NULL,
    vendor_code character varying(20) NOT NULL,
    name character varying(100) NOT NULL,
    contact_person character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20) NOT NULL,
    address text NOT NULL,
    city character varying(50) NOT NULL,
    state character varying(50) NOT NULL,
    postal_code character varying(20) NOT NULL,
    country character varying(50) NOT NULL,
    category character varying(50) NOT NULL,
    tax_id character varying(50),
    payment_terms character varying(100),
    website character varying(255),
    notes text,
    status character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.vendors OWNER TO vikasalagarsamy;

--
-- Name: vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.vendors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendors_id_seq OWNER TO vikasalagarsamy;

--
-- Name: vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.vendors_id_seq OWNED BY public.vendors.id;


--
-- Name: whatsapp_config; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.whatsapp_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_phone_number_id text NOT NULL,
    access_token text NOT NULL,
    webhook_verify_token text NOT NULL,
    webhook_url text NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.whatsapp_config OWNER TO vikasalagarsamy;

--
-- Name: whatsapp_messages; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.whatsapp_messages (
    id integer NOT NULL,
    quotation_id integer,
    client_phone character varying(20) NOT NULL,
    message_text text NOT NULL,
    message_type character varying(20) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    interakt_message_id character varying(100),
    media_url text,
    media_type character varying(50),
    ai_analyzed boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.whatsapp_messages OWNER TO vikasalagarsamy;

--
-- Name: whatsapp_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.whatsapp_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.whatsapp_messages_id_seq OWNER TO vikasalagarsamy;

--
-- Name: whatsapp_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.whatsapp_messages_id_seq OWNED BY public.whatsapp_messages.id;


--
-- Name: whatsapp_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.whatsapp_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_name text NOT NULL,
    template_type text NOT NULL,
    template_content text NOT NULL,
    variables jsonb DEFAULT '[]'::jsonb,
    language_code text DEFAULT 'en'::text,
    status text DEFAULT 'pending'::text,
    ai_optimized boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.whatsapp_templates OWNER TO vikasalagarsamy;

--
-- Name: accounting_workflows id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.accounting_workflows ALTER COLUMN id SET DEFAULT nextval('public.accounting_workflows_id_seq'::regclass);


--
-- Name: action_recommendations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.action_recommendations ALTER COLUMN id SET DEFAULT nextval('public.action_recommendations_id_seq'::regclass);


--
-- Name: ai_behavior_settings id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_behavior_settings ALTER COLUMN id SET DEFAULT nextval('public.ai_behavior_settings_id_seq'::regclass);


--
-- Name: ai_communication_tasks id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_communication_tasks ALTER COLUMN id SET DEFAULT nextval('public.ai_communication_tasks_id_seq'::regclass);


--
-- Name: ai_configurations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_configurations ALTER COLUMN id SET DEFAULT nextval('public.ai_configurations_id_seq'::regclass);


--
-- Name: ai_prompt_templates id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_prompt_templates ALTER COLUMN id SET DEFAULT nextval('public.ai_prompt_templates_id_seq'::regclass);


--
-- Name: ai_tasks id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_tasks ALTER COLUMN id SET DEFAULT nextval('public.ai_tasks_id_seq'::regclass);


--
-- Name: branches id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.branches ALTER COLUMN id SET DEFAULT nextval('public.branches_id_seq'::regclass);


--
-- Name: business_trends id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.business_trends ALTER COLUMN id SET DEFAULT nextval('public.business_trends_id_seq'::regclass);


--
-- Name: call_triggers id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.call_triggers ALTER COLUMN id SET DEFAULT nextval('public.call_triggers_id_seq'::regclass);


--
-- Name: client_communication_timeline id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.client_communication_timeline ALTER COLUMN id SET DEFAULT nextval('public.client_communication_timeline_id_seq'::regclass);


--
-- Name: client_insights id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.client_insights ALTER COLUMN id SET DEFAULT nextval('public.client_insights_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: communications id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.communications ALTER COLUMN id SET DEFAULT nextval('public.communications_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: conversation_sessions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.conversation_sessions ALTER COLUMN id SET DEFAULT nextval('public.conversation_sessions_id_seq'::regclass);


--
-- Name: deliverable_master id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.deliverable_master ALTER COLUMN id SET DEFAULT nextval('public.deliverable_master_id_seq'::regclass);


--
-- Name: deliverables id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.deliverables ALTER COLUMN id SET DEFAULT nextval('public.deliverables_id_seq'::regclass);


--
-- Name: department_instructions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.department_instructions ALTER COLUMN id SET DEFAULT nextval('public.department_instructions_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: designation_menu_permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions ALTER COLUMN id SET DEFAULT nextval('public.designation_menu_permissions_id_seq'::regclass);


--
-- Name: designations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designations ALTER COLUMN id SET DEFAULT nextval('public.designations_id_seq'::regclass);


--
-- Name: dynamic_menus id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.dynamic_menus ALTER COLUMN id SET DEFAULT nextval('public.dynamic_menus_id_seq'::regclass);


--
-- Name: employee_companies id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_companies ALTER COLUMN id SET DEFAULT nextval('public.employee_companies_id_seq'::regclass);


--
-- Name: employee_devices id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_devices ALTER COLUMN id SET DEFAULT nextval('public.employee_devices_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: instagram_analytics id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_analytics ALTER COLUMN id SET DEFAULT nextval('public.instagram_analytics_id_seq'::regclass);


--
-- Name: instagram_comments id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_comments ALTER COLUMN id SET DEFAULT nextval('public.instagram_comments_id_seq'::regclass);


--
-- Name: instagram_interactions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_interactions ALTER COLUMN id SET DEFAULT nextval('public.instagram_interactions_id_seq'::regclass);


--
-- Name: instagram_mentions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_mentions ALTER COLUMN id SET DEFAULT nextval('public.instagram_mentions_id_seq'::regclass);


--
-- Name: instagram_messages id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_messages ALTER COLUMN id SET DEFAULT nextval('public.instagram_messages_id_seq'::regclass);


--
-- Name: instagram_story_mentions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_story_mentions ALTER COLUMN id SET DEFAULT nextval('public.instagram_story_mentions_id_seq'::regclass);


--
-- Name: instruction_approvals id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instruction_approvals ALTER COLUMN id SET DEFAULT nextval('public.instruction_approvals_id_seq'::regclass);


--
-- Name: lead_drafts id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_drafts ALTER COLUMN id SET DEFAULT nextval('public.lead_drafts_id_seq'::regclass);


--
-- Name: lead_followups id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_followups ALTER COLUMN id SET DEFAULT nextval('public.lead_followups_id_seq'::regclass);


--
-- Name: lead_sources id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_sources ALTER COLUMN id SET DEFAULT nextval('public.lead_sources_id_seq'::regclass);


--
-- Name: lead_task_performance id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_task_performance ALTER COLUMN id SET DEFAULT nextval('public.lead_task_performance_id_seq'::regclass);


--
-- Name: leads id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.leads ALTER COLUMN id SET DEFAULT nextval('public.leads_id_seq'::regclass);


--
-- Name: management_insights id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.management_insights ALTER COLUMN id SET DEFAULT nextval('public.management_insights_id_seq'::regclass);


--
-- Name: menu_items id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items ALTER COLUMN id SET DEFAULT nextval('public.menu_items_id_seq'::regclass);


--
-- Name: menu_items_tracking id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items_tracking ALTER COLUMN id SET DEFAULT nextval('public.menu_items_tracking_id_seq'::regclass);


--
-- Name: message_analysis id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.message_analysis ALTER COLUMN id SET DEFAULT nextval('public.message_analysis_id_seq'::regclass);


--
-- Name: ml_model_performance id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ml_model_performance ALTER COLUMN id SET DEFAULT nextval('public.ml_model_performance_id_seq'::regclass);


--
-- Name: notification_batches id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_batches ALTER COLUMN id SET DEFAULT nextval('public.notification_batches_id_seq'::regclass);


--
-- Name: partners id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.partners ALTER COLUMN id SET DEFAULT nextval('public.partners_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: post_sale_confirmations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sale_confirmations ALTER COLUMN id SET DEFAULT nextval('public.post_sale_confirmations_id_seq'::regclass);


--
-- Name: post_sales_workflows id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sales_workflows ALTER COLUMN id SET DEFAULT nextval('public.post_sales_workflows_id_seq'::regclass);


--
-- Name: query_performance_logs id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.query_performance_logs ALTER COLUMN id SET DEFAULT nextval('public.query_performance_logs_id_seq'::regclass);


--
-- Name: quotation_approvals id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_approvals ALTER COLUMN id SET DEFAULT nextval('public.quotation_approvals_id_seq'::regclass);


--
-- Name: quotation_business_lifecycle id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_business_lifecycle ALTER COLUMN id SET DEFAULT nextval('public.quotation_business_lifecycle_id_seq'::regclass);


--
-- Name: quotation_edit_approvals id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_edit_approvals ALTER COLUMN id SET DEFAULT nextval('public.quotation_edit_approvals_id_seq'::regclass);


--
-- Name: quotation_events id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_events ALTER COLUMN id SET DEFAULT nextval('public.quotation_events_id_seq'::regclass);


--
-- Name: quotation_predictions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_predictions ALTER COLUMN id SET DEFAULT nextval('public.quotation_predictions_id_seq'::regclass);


--
-- Name: quotation_revisions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_revisions ALTER COLUMN id SET DEFAULT nextval('public.quotation_revisions_id_seq'::regclass);


--
-- Name: quotation_workflow_history id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_workflow_history ALTER COLUMN id SET DEFAULT nextval('public.quotation_workflow_history_id_seq'::regclass);


--
-- Name: quotations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotations ALTER COLUMN id SET DEFAULT nextval('public.quotations_id_seq'::regclass);


--
-- Name: quote_components id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_components ALTER COLUMN id SET DEFAULT nextval('public.quote_components_id_seq'::regclass);


--
-- Name: quote_deliverables_snapshot id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_deliverables_snapshot ALTER COLUMN id SET DEFAULT nextval('public.quote_deliverables_snapshot_id_seq'::regclass);


--
-- Name: quote_services_snapshot id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_services_snapshot ALTER COLUMN id SET DEFAULT nextval('public.quote_services_snapshot_id_seq'::regclass);


--
-- Name: revenue_forecasts id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.revenue_forecasts ALTER COLUMN id SET DEFAULT nextval('public.revenue_forecasts_id_seq'::regclass);


--
-- Name: role_menu_access id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_menu_access ALTER COLUMN id SET DEFAULT nextval('public.role_menu_access_id_seq'::regclass);


--
-- Name: role_menu_permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_menu_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_menu_permissions_id_seq'::regclass);


--
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: sales_activities id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_activities ALTER COLUMN id SET DEFAULT nextval('public.sales_activities_id_seq'::regclass);


--
-- Name: sales_performance_metrics id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_performance_metrics ALTER COLUMN id SET DEFAULT nextval('public.sales_performance_metrics_id_seq'::regclass);


--
-- Name: sales_team_members id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_team_members ALTER COLUMN id SET DEFAULT nextval('public.sales_team_members_id_seq'::regclass);


--
-- Name: sequence_rules id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sequence_rules ALTER COLUMN id SET DEFAULT nextval('public.sequence_rules_id_seq'::regclass);


--
-- Name: sequence_steps id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sequence_steps ALTER COLUMN id SET DEFAULT nextval('public.sequence_steps_id_seq'::regclass);


--
-- Name: service_packages id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.service_packages ALTER COLUMN id SET DEFAULT nextval('public.service_packages_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- Name: system_logs id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.system_logs ALTER COLUMN id SET DEFAULT nextval('public.system_logs_id_seq'::regclass);


--
-- Name: task_generation_log id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_generation_log ALTER COLUMN id SET DEFAULT nextval('public.task_generation_log_id_seq'::regclass);


--
-- Name: task_performance_metrics id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_performance_metrics ALTER COLUMN id SET DEFAULT nextval('public.task_performance_metrics_id_seq'::regclass);


--
-- Name: task_sequence_templates id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_sequence_templates ALTER COLUMN id SET DEFAULT nextval('public.task_sequence_templates_id_seq'::regclass);


--
-- Name: task_status_history id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_status_history ALTER COLUMN id SET DEFAULT nextval('public.task_status_history_id_seq'::regclass);


--
-- Name: team_performance_trends id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.team_performance_trends ALTER COLUMN id SET DEFAULT nextval('public.team_performance_trends_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: unified_role_permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.unified_role_permissions ALTER COLUMN id SET DEFAULT nextval('public.unified_role_permissions_id_seq'::regclass);


--
-- Name: user_accounts id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_accounts ALTER COLUMN id SET DEFAULT nextval('public.user_accounts_id_seq'::regclass);


--
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- Name: vendors id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.vendors ALTER COLUMN id SET DEFAULT nextval('public.vendors_id_seq'::regclass);


--
-- Name: whatsapp_messages id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.whatsapp_messages ALTER COLUMN id SET DEFAULT nextval('public.whatsapp_messages_id_seq'::regclass);


--
-- Data for Name: accounting_workflows; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.accounting_workflows (id, quotation_id, payment_id, instruction_id, status, total_amount, payment_type, processed_by, processed_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: action_recommendations; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.action_recommendations (id, quotation_id, recommendation_type, priority, confidence_score, title, description, suggested_action, expected_impact, reasoning, is_completed, completed_at, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.activities (id, action_type, entity_type, entity_id, entity_name, description, user_id, user_name, created_at) FROM stdin;
bb61eb85-b30d-4337-8a01-be6a336fc8c0	create	company	2	ONE OF A KIND	Company "ONE OF A KIND" was added	\N	Admin User	2025-06-13 05:31:47.242+05:30
bd236a31-2933-43f1-81c0-b74650100ecf	create	lead	2	L0001	Created new lead L0001 for Ramya (Source: Instagram)	\N	Current User	2025-06-13 05:58:32.961+05:30
9b4fd172-35b2-4762-b94b-fb2d0583438e	create	company	3	WEDDINGS BY OOAK	Company "WEDDINGS BY OOAK" was added	\N	Admin User	2025-06-13 15:55:48.332+05:30
2e850b73-07c6-4bc4-b41a-7f3d0315eb70	create	company	4	YOUR PERFECT STORY	Company "YOUR PERFECT STORY" was added	\N	Admin User	2025-06-13 15:56:06.15+05:30
78c8e799-65fb-4a0f-bccc-601605597edd	create	lead	3	L0002	Created new lead L0002 for Kruthika (Source: Instagram)	\N	Current User	2025-06-13 16:55:41.017+05:30
b59accac-b0a5-47b0-9328-f852ed5a83c0	create	lead	4	L0002	Created new lead L0002 for Jothi Alagarsamy (Source: Instagram)	\N	Current User	2025-06-13 17:01:49.498+05:30
f94ebafa-e80d-4eef-9d8a-3b1b5934b796	create	lead	5	L0002	Created new lead L0002 for Jothi Alagarsamy (Source: Instagram)	\N	Current User	2025-06-14 06:00:51.561+05:30
5d4732dc-2b11-4a74-9932-44cd55dcfacc	create	lead	6	L0003	Created new lead L0003 for Pradeep (Source: Instagram)	\N	Current User	2025-06-14 11:53:31.572+05:30
8b7ab280-2a43-44ea-8ac0-e3d4ed4321e9	create	lead	9	L0004	Created new lead L0004 for Dev (Source: Instagram)	\N	Current User	2025-06-14 15:17:04.003+05:30
800f9610-768a-4cda-97d1-519d59f07457	create	lead	10	L0005	Created new lead L0005 for Abhi (Source: Instagram)	\N	Current User	2025-06-14 15:30:18.373+05:30
2bcad7da-8d46-4dbe-b658-2459d758f3c6	create	lead	11	L0006	Created new lead L0006 for Harish (Source: Instagram)	\N	Current User	2025-06-14 16:02:35.899+05:30
a44ebcc2-a2bb-4dc4-a853-6bc690d4defc	create	lead	12	L0007	Created new lead L0007 for Navya Vikas (Source: Instagram)	\N	Current User	2025-06-17 21:58:41.118+05:30
\.


--
-- Data for Name: ai_behavior_settings; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.ai_behavior_settings (id, setting_key, setting_value, description, category, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: ai_communication_tasks; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.ai_communication_tasks (id, quotation_id, conversation_session_id, task_type, title, description, priority, assigned_to_employee_id, due_date, status, ai_reasoning, trigger_message_id, created_by_ai, created_at, updated_at) FROM stdin;
1	1	\N	follow_up	Follow up with client - Ramya	Initial follow-up after quotation approval. Monitor client communication and ensure smooth onboarding. Quotation: QT-2025-0001 (₹2,45,000)	medium	6	2025-06-14 04:30:48.997	pending	Automatic task created after quotation approval to ensure timely client follow-up and communication monitoring	\N	t	2025-06-13 04:30:48.998	2025-06-13 04:30:48.998
2	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:03:20.108	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:03:20.122	2025-06-13 05:03:20.122
3	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:03:25.362	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:03:25.381	2025-06-13 05:03:25.381
4	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:11:16.153	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:11:16.165	2025-06-13 05:11:16.165
5	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:11:22.735	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:11:22.744	2025-06-13 05:11:22.744
6	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:11:50.603	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:11:50.613	2025-06-13 05:11:50.613
7	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:11:51.923	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:11:51.933	2025-06-13 05:11:51.933
8	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:12:54.066	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:12:54.076	2025-06-13 05:12:54.076
9	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:12:54.905	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:12:54.914	2025-06-13 05:12:54.914
10	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:13:29.569	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:13:29.58	2025-06-13 05:13:29.58
11	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:13:32.263	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:13:32.272	2025-06-13 05:13:32.272
12	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:17:05.585	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:17:05.603	2025-06-13 05:17:05.603
13	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:17:09.758	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:17:09.77	2025-06-13 05:17:09.77
14	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:17:38.766	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:17:38.776	2025-06-13 05:17:38.776
15	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:17:42.169	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:17:42.178	2025-06-13 05:17:42.178
16	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:18:04.428	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:18:04.437	2025-06-13 05:18:04.437
17	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:18:08.545	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:18:08.553	2025-06-13 05:18:08.553
18	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:27:57.673	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:27:57.697	2025-06-13 05:27:57.697
19	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:29:25.595	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:29:25.607	2025-06-13 05:29:25.607
20	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:29:50.396	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:29:50.407	2025-06-13 05:29:50.407
21	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:30:20.573	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:30:20.583	2025-06-13 05:30:20.583
22	1	\N	follow_up	Manual Review Required	AI analysis failed - please review conversation manually	medium	6	2025-06-14 05:32:43.17	pending	Fallback task due to LLM connection issue	\N	t	2025-06-13 05:32:43.18	2025-06-13 05:32:43.18
\.


--
-- Data for Name: ai_configurations; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.ai_configurations (id, config_key, config_type, config_value, version, is_active, created_by, created_at, updated_at, description) FROM stdin;
1	hallucination_prevention	guidelines	CRITICAL INSTRUCTION: NEVER make up or invent data. ONLY use information provided in this context. If you don't have specific information, say "I don't have those details" instead of creating fictional data.\n\nANTI-HALLUCINATION RULES:\n- NEVER create fake dates, events, or historical information\n- NEVER invent client conversations or interactions  \n- NEVER make up quotation details not in the database\n- If asked about specific events/dates, only reference actual database records\n- When unsure, explicitly state "I don't have that information"\n- Always cite data sources when making claims	1	t	00000000-0000-0000-0000-000000000001	2025-06-18 16:04:25.016+05:30	2025-06-18 16:04:25.016+05:30	Auto-healed configuration for hallucination_prevention
2	business_personality	personality	You are Vikas's strategic business partner and AI advisor for his creative photography business. You know EVERYTHING about his operations, clients, finances, and team - like a business co-founder would.\n\nBUSINESS PARTNER PERSONALITY:\n🎯 STRATEGIC THINKING: Always think 2-3 steps ahead for the business\n📊 DATA-DRIVEN: Reference specific numbers, clients, and trends from his actual data  \n💡 SOLUTION-FOCUSED: Don't just identify problems - propose actionable solutions\n🤝 PEER-LEVEL COMMUNICATION: Talk as an equal business partner, not a service assistant\n📈 GROWTH-MINDED: Always look for revenue opportunities and efficiency improvements\n\nCOMMUNICATION STYLE:\n- Talk like you're sitting across from him at a business meeting\n- Skip pleasantries - get straight to business insights\n- Use "we" when talking about the business (you're partners)\n- Reference specific clients by name when relevant\n- Give hard truths when needed (low conversion rates, follow-up delays, etc.)\n- Suggest concrete next actions with timelines\n- Think strategically about business growth and client relationships\n\nKNOWLEDGE DEPTH:\n- You know every client's status, preferences, and history\n- You understand the photography business model and pricing\n- You track cash flow, conversion rates, and team performance\n- You can spot patterns in client behavior and seasonal trends\n- You know which clients need follow-ups and why\n\nRespond as if you're his business co-founder who's been with him from day one.	1	t	00000000-0000-0000-0000-000000000001	2025-06-18 16:04:25.02+05:30	2025-06-18 16:04:25.02+05:30	Auto-healed configuration for business_personality
3	data_validation_rules	guidelines	DATA VALIDATION REQUIREMENTS:\n- All financial figures must come from actual quotations table\n- All client names must match database records exactly\n- All event dates must come from quotation_events table\n- All employee information must come from employees table\n- Revenue calculations must be based on approved quotations only\n- Lead conversion rates must be calculated from actual leads data	1	t	00000000-0000-0000-0000-000000000001	2025-06-18 16:04:25.022+05:30	2025-06-18 16:04:25.022+05:30	Auto-healed configuration for data_validation_rules
\.


--
-- Data for Name: ai_contacts; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.ai_contacts (id, phone, country_code, name, source_id, source_url, internal_lead_source, internal_closure_date, created_at) FROM stdin;
\.


--
-- Data for Name: ai_decision_log; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.ai_decision_log (id, notification_id, decision_type, decision_data, model_version, confidence_score, execution_time, created_at) FROM stdin;
\.


--
-- Data for Name: ai_performance_tracking; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.ai_performance_tracking (id, model_type, prediction_data, actual_outcome, accuracy_score, confidence_score, model_version, feedback_loop_data, created_at) FROM stdin;
\.


--
-- Data for Name: ai_prompt_templates; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.ai_prompt_templates (id, template_name, template_content, variables, category, is_default, version, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: ai_recommendations; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.ai_recommendations (id, user_id, recommendation_type, recommendation_data, confidence_score, context_data, applied, feedback_score, expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: ai_tasks; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.ai_tasks (id, task_title, task_description, priority, status, due_date, category, assigned_to, assigned_by, metadata, completed_at, created_at, updated_at, client_name, business_impact, ai_reasoning, estimated_value, lead_id, quotation_id, actual_hours, quality_rating, assigned_to_employee_id, task_type, completion_notes, employee_id) FROM stdin;
148	Test Task API Migration	Testing PostgreSQL migration	high	pending	2025-06-20 15:30:00+05:30	\N	\N	\N	\N	\N	2025-06-19 09:12:43.734+05:30	2025-06-19 09:12:43.734+05:30	\N	medium	\N	0.00	\N	\N	\N	\N	\N	general	\N	\N
\.


--
-- Data for Name: analytics_cache; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.analytics_cache (id, cache_key, cache_data, cache_type, expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: analytics_metrics; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.analytics_metrics (id, metric_name, metric_type, metric_value, metric_unit, dimensions, time_period, recorded_at, created_at) FROM stdin;
\.


--
-- Data for Name: branches; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.branches (id, company_id, name, address, phone, email, manager_id, is_remote, created_at, updated_at, branch_code, location) FROM stdin;
1	2	CHENNAI	Plot No: 17 & 17A, Old Door No: 446/2, New Door No.339 1st Floor, Poonamallee High Rd, near by D.G Vaishnav College, Arumbakkam,	+919677362524	hello@ooak.photography	\N	f	2025-06-13 05:32:22.884+05:30	2025-06-13 05:32:22.884+05:30	OOAKCHE	\N
2	3	COIMBATORE	Sai Baba Colony,\nCoimbatore	+919500999861	vikas.alagarsamy1987@gmail.com	\N	f	2025-06-13 15:56:36.33+05:30	2025-06-13 15:56:36.33+05:30	WBOOAKCOI	\N
3	2	BANGALORE	2/5, Subbaraju road, JB Nagar,\nmaruthi sevanagar	+919480185770	navyavikas14@gmail.com	\N	f	2025-06-13 15:56:47.638+05:30	2025-06-13 15:56:47.638+05:30	OOAKBAN	\N
4	2	HYDERABAD	2/5, Subbaraju road, JB Nagar,\nmaruthi sevanagar	+919480185770	pradeep@gmail.com	\N	f	2025-06-13 15:56:56.292+05:30	2025-06-13 15:56:56.292+05:30	OOAKHYD	\N
5	4	CHENNAI	15/34, Thirumangalam Road, Navalar Nagar, Anna Nagar West,	\N	vikas@ooak.photography	\N	f	2025-06-13 15:57:21.576+05:30	2025-06-23 12:51:55.140658+05:30	YPSCHE	Chennai
7	1	DUBAI	dubai	\N	\N	\N	f	2025-06-23 12:57:48.222855+05:30	2025-06-23 12:57:48.222855+05:30	OOAKAIDUB	DUBAI
\.


--
-- Data for Name: bug_attachments; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.bug_attachments (id, bug_id, file_name, file_path, file_type, file_size, uploaded_by, created_at) FROM stdin;
\.


--
-- Data for Name: bug_comments; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.bug_comments (id, bug_id, user_id, content, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: bugs; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.bugs (id, title, description, severity, status, assignee_id, reporter_id, due_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: business_rules; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.business_rules (id, name, description, department, task_type, priority, due_after_hours, due_after_days, enabled, conditions, created_at, updated_at, created_by, updated_by) FROM stdin;
sales_initial_followup	Initial Follow-up Call	First contact after quotation sent	Sales	quotation_follow_up	high	2	0	t	{"min_value": 0, "status_triggers": ["sent", "pending"], "urgency_multiplier": 1}	2025-06-12 23:32:55.136+05:30	2025-06-12 23:32:55.136+05:30	\N	\N
sales_whatsapp_checkin	WhatsApp Check-in	WhatsApp follow-up message	Sales	client_communication	medium	24	1	t	{"min_value": 10000, "status_triggers": ["sent"], "urgency_multiplier": 1.2}	2025-06-12 23:32:55.136+05:30	2025-06-12 23:32:55.136+05:30	\N	\N
sales_detailed_discussion	Detailed Discussion	In-depth conversation about requirements	Sales	client_meeting	medium	72	3	t	{"min_value": 50000, "status_triggers": ["sent", "interested"], "urgency_multiplier": 1.5}	2025-06-12 23:32:55.136+05:30	2025-06-12 23:32:55.136+05:30	\N	\N
sales_payment_followup	Payment Follow-up	Chase payment for approved quotations	Sales	payment_follow_up	urgent	168	7	t	{"min_value": 1000, "status_triggers": ["approved"], "urgency_multiplier": 2}	2025-06-12 23:32:55.136+05:30	2025-06-12 23:32:55.136+05:30	\N	\N
ops_project_kickoff	Project Kickoff	Schedule project start after payment	Operations	project_management	high	48	2	t	{"min_value": 0, "status_triggers": ["payment_received"], "urgency_multiplier": 1}	2025-06-12 23:33:03.865+05:30	2025-06-12 23:33:03.865+05:30	\N	\N
ops_weekly_update	Weekly Progress Update	Regular project status updates	Operations	progress_tracking	medium	168	7	t	{"min_value": 0, "status_triggers": ["in_progress"], "urgency_multiplier": 1}	2025-06-12 23:33:03.865+05:30	2025-06-12 23:33:03.865+05:30	\N	\N
accounts_invoice_generation	Invoice Generation	Generate invoice after approval	Accounts	invoice_generation	high	24	1	t	{"min_value": 0, "status_triggers": ["approved"], "urgency_multiplier": 1}	2025-06-12 23:33:03.865+05:30	2025-06-12 23:33:03.865+05:30	\N	\N
accounts_payment_reminder	Payment Reminder	Send payment reminder to clients	Accounts	payment_reminder	urgent	240	10	t	{"min_value": 0, "status_triggers": ["invoice_sent"], "urgency_multiplier": 1.8}	2025-06-12 23:33:03.865+05:30	2025-06-12 23:33:03.865+05:30	\N	\N
lead_follow_up_rule	Lead Follow-up Rule	Create follow-up tasks for assigned leads	SALES	lead_follow_up	high	24	1	t	{"lead_status": "ASSIGNED", "days_since_assignment": 0}	2025-06-18 06:47:44.381+05:30	2025-06-18 06:47:44.381+05:30	\N	\N
\.


--
-- Data for Name: business_trends; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.business_trends (id, trend_type, trend_period, trend_direction, trend_strength, current_value, previous_value, percentage_change, statistical_significance, insights, recommendations, analyzed_at) FROM stdin;
\.


--
-- Data for Name: call_analytics; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.call_analytics (id, call_id, overall_sentiment, sentiment_score, client_sentiment, agent_sentiment, call_intent, key_topics, business_outcomes, action_items, agent_professionalism_score, agent_responsiveness_score, agent_knowledge_score, agent_closing_effectiveness, client_engagement_level, client_interest_level, client_objection_handling, client_buying_signals, forbidden_words_detected, compliance_issues, risk_level, talk_time_ratio, interruptions, silent_periods, call_quality_score, quote_discussed, budget_mentioned, timeline_discussed, next_steps_agreed, follow_up_required, created_at, updated_at) FROM stdin;
c666ee7d-0771-4b00-b19d-bc59860e6928	dc242ae9-c1a4-429f-a754-9ce133f665dd	positive	0.50	positive	positive	wedding_inquiry	["wedding", "photography", "packages"]	["quote_requested"]	["send_proposal"]	8	8	8	7	high	high	[]	["asked_for_proposal"]	[]	[]	low	1.20	0	0	8.5	t	f	t	t	t	2025-06-19 10:12:00.327+05:30	2025-06-19 10:12:00.324+05:30
\.


--
-- Data for Name: call_insights; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.call_insights (id, call_id, conversion_indicators, objection_patterns, successful_techniques, improvement_areas, decision_factors, pain_points, preferences, concerns, market_trends, competitive_mentions, pricing_feedback, service_feedback, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: call_transcriptions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.call_transcriptions (id, call_id, task_id, lead_id, client_name, sales_agent, phone_number, duration, recording_url, transcript, confidence_score, language, created_at, updated_at, detected_language, status, notes, call_direction, call_status) FROM stdin;
44288642-d7a3-4571-9027-e28857356a1d	mobile_EMP001_919677362524_1750057695963	\N	\N	Mobile Call - +919677362524	EMP001	+919677362524	0	\N	outgoing call connected	1.00	en	2025-06-16 12:38:15.807+05:30	2025-06-16 12:38:15.963+05:30	\N	processing	Direction: outgoing	outgoing	connected
e3dd3d4b-d326-4055-b45d-ab88ba77afb6	mobile_EMP001_7358144070_1750057748231	\N	\N	Mobile Call - 7358144070	EMP001	7358144070	6	\N	Unanswered call - agent called but client did not answer	1.00	en	2025-06-16 12:39:01.71+05:30	2025-06-16 12:39:08.231+05:30	\N	completed	Direction: outgoing	outgoing	unanswered
4b72d17d-63c1-46e2-a3be-d32a0dac4fc4	mobile_EMP001_919677362524_1750065148178	\N	\N	Incoming Call - +919677362524	EMP001	+919677362524	30	\N	Missed call - client called but agent did not answer	1.00	en	2025-06-16 14:42:28.068+05:30	2025-06-16 14:42:58.541+05:30	\N	completed	Direction: incoming	incoming	missed
69904397-2adb-4f6c-b52c-f87763be6319	mobile_EMP001_919876543210_1750058412320	\N	\N	Test Answered Call	EMP001	+919876543210	45	\N	incoming call answered	1.00	en	2025-06-16 12:50:12.32+05:30	2025-06-16 12:50:15.81+05:30	\N	completed	Direction: incoming	incoming	answered
4f3cf19e-15cc-490e-8f46-41d53ae89705	mobile_EMP001_919677362524_1750059479501	\N	\N	Incoming Call - +919677362524	EMP001	+919677362524	1	\N	Missed call - client called but agent did not answer	1.00	en	2025-06-16 13:07:59.48+05:30	2025-06-16 13:08:01.316+05:30	\N	completed	Direction: incoming	incoming	missed
6a2c15a0-bd91-4cfe-9ffc-4634473bd248	mobile_EMP001_919677362524_1750071882753	\N	\N	Ramya	EMP001	+919677362524	15	\N	Missed call - client called but agent did not answer	1.00	en	2025-06-16 16:34:42.674+05:30	2025-06-16 16:34:58.31+05:30	\N	completed	Direction: incoming	incoming	missed
c80b479a-99e1-4595-90e5-bfaf35026dab	mobile_EMP001_7358144070_1750064387887	\N	\N	Mobile Call - 7358144070	EMP001	7358144070	37	\N	outgoing call answered	1.00	en	2025-06-16 14:29:47.823+05:30	2025-06-16 14:30:25.461+05:30	\N	completed	Direction: outgoing	outgoing	answered
4370b525-b1b9-4108-8e94-2146e44e0cb6	mobile_EMP001_919876543210_1750082389935	\N	\N	Real-Time Test Call	EMP001	+919876543210	0	\N	outgoing call completed successfully	1.00	en	2025-06-16 19:29:49.864+05:30	2025-06-16 19:29:55.018+05:30	\N	completed	Direction: outgoing	outgoing	completed
b0501d45-29ca-4f3c-8e3b-9d65d416f274	mobile_EMP-25-0001_919876543210_1750083936793	\N	\N	Real-Time Test	EMP-25-0001	+919876543210	0	\N	outgoing call completed successfully	1.00	en	2025-06-16 19:55:36.793+05:30	2025-06-16 19:55:36.793+05:30	\N	completed	Direction: outgoing	outgoing	completed
7c8472c3-e1ba-4cb9-8e94-4907874e68c1	mobile_EMP-25-0001_919677362524_1750122049702	\N	\N	Ramya	EMP-25-0001	+919677362524	40	\N	outgoing call answered	1.00	en	2025-06-17 06:30:49.565+05:30	2025-06-17 06:32:48.694+05:30	\N	completed	Direction: outgoing	outgoing	answered
040248c7-6193-43ff-a8e1-035b916886fe	040248c7-6193-43ff-a8e1-035b916886fe	\N	\N	Test Contact	Employee EMP-25-0001	9999999999	60	http://localhost:3000/api/call-recordings/file/android_EMP-25-0001_1750124830529.mp3	Processing failed: Translation failed: Command failed: source whisper-env/bin/activate && python "/Users/vikasalagarsamy/OOAK-FUTURE/scripts/faster-whisper-translate.py" "/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/android_EMP-25-0001_1750124830529.mp3" "large-v3"\n	0.00	en	2025-06-17 07:16:10.281+05:30	2025-06-17 07:17:10.53+05:30	unknown	error	Android upload from device aef21d11c36e3b2e. Direction: outgoing	outgoing	processing
27980412-5cfe-4dee-a155-fc9e80ec5873	mobile_EMP-25-0001_919677362524_1750131133451	\N	\N	Ramya	EMP-25-0001	+919677362524	29	\N	outgoing call answered	1.00	en	2025-06-17 09:02:12.569+05:30	2025-06-17 09:02:42.245+05:30	\N	completed	Direction: outgoing	outgoing	answered
3315c359-3a10-4d01-a302-39e3713047b6	mobile_EMP-25-0001_919677362524_1750132846660	\N	\N	Ramya	EMP-25-0001	+919677362524	10	https://portal.ooak.photography/api/call-recordings/file/android_EMP-25-0001_1750132798134.m4a	outgoing call completed successfully - recording available	1.00	en	2025-06-17 09:30:46.66+05:30	2025-06-17 09:34:03.538+05:30	\N	completed	Direction: outgoing	outgoing	completed
ec81f66b-5895-4449-a8ea-ac2fdec59a2d	ec81f66b-5895-4449-a8ea-ac2fdec59a2d	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/2990e77d-142f-4e10-8a97-7190072e2978_1750141113597_Call recording Vikas Alagarsamy_250616_100915.m4a	Processing...	0.00	en	2025-06-17 11:48:33.599+05:30	2025-06-17 11:48:33.606+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
eccc94c1-56f4-45d3-9b5f-da0b58fe2bf1	eccc94c1-56f4-45d3-9b5f-da0b58fe2bf1	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/5b5c5e65-6394-4093-9cdb-e6adf0a45535_1750141113773_Call recording Vikas Alagarsamy_250616_100915.m4a	Processing...	0.00	en	2025-06-17 11:48:33.774+05:30	2025-06-17 11:48:33.776+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
6422c546-857d-43c7-bc97-c4e97cf642e0	6422c546-857d-43c7-bc97-c4e97cf642e0	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/094e11e4-09df-4583-a370-95421377bb11_1750141115597_Call recording Vikas Alagarsamy_250616_101917.m4a	Processing...	0.00	en	2025-06-17 11:48:35.598+05:30	2025-06-17 11:48:35.599+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
e2fe116c-9271-4439-b18a-1001a2b9c3ab	e2fe116c-9271-4439-b18a-1001a2b9c3ab	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/893a4889-11bc-44e5-876b-4b84cf669c5b_1750141115694_Call recording Vikas Alagarsamy_250616_101638.m4a	Processing...	0.00	en	2025-06-17 11:48:35.695+05:30	2025-06-17 11:48:35.696+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
1a6fca5b-5a90-48cd-9467-c131a6ff8921	1a6fca5b-5a90-48cd-9467-c131a6ff8921	\N	\N	Sandhya	Photography AI Assistant	+91-UNKNOWN	0	/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/60e6b726-5180-49ec-b837-46eb3a7f51c6_1749972140366_123.mp3	Processing...	0.00	en	2025-06-15 12:52:20.366+05:30	2025-06-15 12:52:20.375+05:30	\N	transcribing	\N	outgoing	transcribing
67a1ad1e-c86b-4127-8b11-55c374c8ec77	67a1ad1e-c86b-4127-8b11-55c374c8ec77	\N	\N	Sandhya	Photography AI Assistant	+91-UNKNOWN	0	/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/95e7d181-2fcc-402a-a7ae-e12ee64630c2_1749972790793_123.mp3	Processing...	0.00	en	2025-06-15 13:03:10.793+05:30	2025-06-15 13:03:10.801+05:30	\N	transcribing	\N	outgoing	transcribing
54e3df32-6594-49c8-9b3f-2b03eb359efc	54e3df32-6594-49c8-9b3f-2b03eb359efc	\N	\N	Sandhya	Photography AI Assistant	+91-UNKNOWN	0	/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/cbc973ab-a5cb-4300-80da-4e855026d3d4_1750033981596_123.mp3	Processing...	0.00	en	2025-06-16 06:03:01.598+05:30	2025-06-16 06:03:01.609+05:30	\N	transcribing	\N	outgoing	transcribing
bfb1a965-0f88-42f8-86c5-84c0933a5c96	mobile_1750034851806	\N	\N	Test Call	EMP001	8825912420	120	\N	outgoing call connected - Mobile monitoring	1.00	en	2025-06-16 06:17:31.806+05:30	2025-06-16 06:17:31.816+05:30	\N	processing	\N	outgoing	connected
a345c25f-6922-4864-b62f-ea27dc232adc	mobile_1750035022468	\N	\N	Test from Android	EMP001	8825912420	27	\N	outgoing call connected - Mobile monitoring	1.00	en	2025-06-16 06:20:22.468+05:30	2025-06-16 06:20:22.472+05:30	\N	processing	\N	outgoing	connected
36d21f59-bd2b-47f6-b204-ba0a692b9b03	mobile_1750035317502	\N	\N	Test Call from Android	EMP001	8825912420	13	\N	outgoing call completed - Mobile monitoring	1.00	en	2025-06-16 06:25:17.502+05:30	2025-06-16 06:25:17.512+05:30	\N	processing	\N	outgoing	processing
0f566107-a21b-486d-9ed4-28663d4cf6e6	mobile_EMP001_8825912420	\N	\N	Mobile Call - 8825912420	EMP001	8825912420	22	\N	outgoing call answered	1.00	en	2025-06-16 06:45:00+05:30	2025-06-16 11:51:29.506+05:30	\N	processing	Direction: outgoing	outgoing	answered
4df05c9f-51f1-4758-b0fa-8f3be37e35a7	mobile_EMP001_919677362524_1750068638968	\N	\N	Ramya	EMP001	+919677362524	13	\N	Unanswered call - agent called but client did not answer	1.00	en	2025-06-16 15:40:38.777+05:30	2025-06-16 15:40:52.037+05:30	\N	completed	Direction: outgoing	outgoing	unanswered
15c29776-600d-4043-8022-b59c937b325b	mobile_EMP-25-0001_9876543210_1750082697858	\N	\N	Test Real-Time Monitor	EMP-25-0001	9876543210	0	\N	outgoing call ringing	1.00	en	2025-06-16 19:34:57.858+05:30	2025-06-16 19:34:57.858+05:30	\N	processing	Direction: outgoing	outgoing	ringing
912226fe-268a-4751-9c6b-3aa47724c9b3	mobile_EMP001_7358144070	\N	\N	Mobile Call - 7358144070	EMP001	7358144070	11	\N	Unanswered call - agent called but client did not answer	1.00	en	2025-06-16 11:54:24.539+05:30	2025-06-16 12:05:51.527+05:30	\N	completed	Direction: outgoing	outgoing	unanswered
2c07b6e2-46d7-4228-9306-3f5349a40a9a	mobile_EMP001_919677362524_1750057717744	\N	\N	Mobile Call - +919677362524	EMP001	+919677362524	21	\N	outgoing call answered	1.00	en	2025-06-16 12:38:15.807+05:30	2025-06-16 12:38:37.744+05:30	\N	processing	Direction: outgoing	outgoing	answered
3ad5e056-ca2b-4e70-910d-ab97bbaf8ee3	mobile_EMP001_919677362524_1750057831134	\N	\N	Incoming Call - +919677362524	EMP001	+919677362524	0	\N	incoming call ringing	1.00	en	2025-06-16 12:40:31.109+05:30	2025-06-16 12:40:31.134+05:30	\N	processing	Direction: incoming	incoming	ringing
f47da904-88cf-4268-8ae4-15dc82a29105	mobile_EMP001_919677362524_1750057838296	\N	\N	Incoming Call - +919677362524	EMP001	+919677362524	7	\N	Missed call - client called but agent did not answer	1.00	en	2025-06-16 12:40:31.109+05:30	2025-06-16 12:40:38.296+05:30	\N	completed	Direction: incoming	incoming	missed
6aabadc9-e319-49f1-bf46-2559c622b502	6aabadc9-e319-49f1-bf46-2559c622b502	\N	\N	VIYA N VIKAS	Photography AI Assistant	+91-UNKNOWN	0	/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/abfe0cf6-0a04-4399-a534-9ab296ecdfbf_1750087008273_123.mp3	Processing...	0.00	en	2025-06-16 20:46:48.273+05:30	2025-06-16 20:46:48.287+05:30	\N	transcribing	\N	outgoing	processing
a96e6381-8fc3-48d2-96fe-d1b37af33a2a	mobile_EMP001_919677362524_1750058472234	\N	\N	Incoming Call - +919677362524	EMP001	+919677362524	8	\N	Missed call - client called but agent did not answer	1.00	en	2025-06-16 12:51:12.208+05:30	2025-06-16 12:51:20.632+05:30	\N	completed	Direction: incoming	incoming	missed
53f5c8c4-855f-4657-a1b3-f8536a978103	mobile_EMP001_919876543210_1750059980769	\N	\N	Test Employee Name	EMP001	+919876543210	0	\N	outgoing call ringing	1.00	en	2025-06-16 13:16:20.769+05:30	2025-06-16 13:16:20.769+05:30	\N	processing	Direction: outgoing	outgoing	ringing
60fdb9fe-f12d-4a23-a184-d1116a782849	mobile_1750036064656	\N	\N	Mobile Call - 8825912420	EMP001	8825912420	0	\N	outgoing call connected - Mobile monitoring	1.00	en	2025-06-16 06:37:44.656+05:30	2025-06-16 06:37:44.659+05:30	\N	processing	\N	outgoing	connected
0685bdec-a8b2-46a9-9760-f53ba458ff36	mobile_1750036079348	\N	\N	Mobile Call - 8825912420	EMP001	8825912420	14	\N	outgoing call completed - Mobile monitoring	1.00	en	2025-06-16 06:37:59.348+05:30	2025-06-16 06:37:59.354+05:30	\N	processing	\N	outgoing	processing
a94dd845-1529-443f-91b2-354707c9f127	mobile_EMP-25-0001_8825912420_1750122195776	\N	\N	Mobile Call - 8825912420	EMP-25-0001	8825912420	51	\N	outgoing call answered	1.00	en	2025-06-17 06:33:15.54+05:30	2025-06-17 06:34:07.347+05:30	\N	completed	Direction: outgoing	outgoing	answered
53213919-fada-4df4-b77f-610350248de3	mobile_EMP001_918825912420	\N	\N	Incoming Test Call	EMP001	+918825912420	30	\N	incoming call completed	1.00	en	2025-06-16 06:46:00+05:30	2025-06-16 07:26:11.221+05:30	\N	completed	Direction: incoming	incoming	completed
4421d6c2-4928-463a-a4f3-ed803e96ecee	4421d6c2-4928-463a-a4f3-ed803e96ecee	\N	\N	Test Contact	Employee EMP-25-0001	9999999999	60	http://localhost:3000/api/call-recordings/file/android_EMP-25-0001_1750124482368.mp3	Processing failed: Translation failed: Command failed: source whisper-env/bin/activate && python "/Users/vikasalagarsamy/OOAK-FUTURE/scripts/faster-whisper-translate.py" "/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/android_EMP-25-0001_1750124482368.mp3" "large-v3"\n	0.00	en	2025-06-17 07:10:21.757+05:30	2025-06-17 07:11:22.373+05:30	unknown	error	Android upload from device aef21d11c36e3b2e. Direction: outgoing	outgoing	processing
77ee9b8b-1616-43fa-8c47-82f52432c7e3	77ee9b8b-1616-43fa-8c47-82f52432c7e3	\N	\N	Vikas Alagarsamy	Employee EMP-25-0001	+919677362524	12	https://portal.ooak.photography/api/call-recordings/file/android_EMP-25-0001_1750132061795.m4a	Processing failed: Translation failed: undefined	0.00	en	2025-06-17 09:02:08+05:30	2025-06-17 09:17:41.796+05:30	unknown	error	Android upload from device manual_upload. Direction: outgoing	outgoing	processing
6a278051-4b71-4682-b74c-eedaa5930775	mobile_EMP-25-0001_919677362524_1750134133577	\N	\N	Ramya	EMP-25-0001	+919677362524	29	\N	outgoing call answered	1.00	en	2025-06-17 09:52:13.372+05:30	2025-06-17 09:52:43.253+05:30	\N	completed	Direction: outgoing	outgoing	answered
b0167c8d-f121-43e2-be72-31b6227dbdaa	mobile_1750036116872	\N	\N	Mobile Call - +918825912420	EMP001	+918825912420	0	\N	incoming call ringing - Mobile monitoring	1.00	en	2025-06-16 06:38:36.872+05:30	2025-06-16 06:38:36.873+05:30	\N	processing	\N	incoming	ringing
63e56f00-ad26-485c-9efd-a21e027ed31b	mobile_1750036120141	\N	\N	Mobile Call - +918825912420	EMP001	+918825912420	0	\N	incoming call connected - Mobile monitoring	1.00	en	2025-06-16 06:38:40.141+05:30	2025-06-16 06:38:40.144+05:30	\N	processing	\N	incoming	connected
5c415d65-6f82-4c5b-8788-e0b26a0298cc	mobile_1750036125617	\N	\N	Mobile Call - +918825912420	EMP001	+918825912420	8	\N	incoming call completed - Mobile monitoring	1.00	en	2025-06-16 06:38:45.617+05:30	2025-06-16 06:38:45.62+05:30	\N	processing	\N	incoming	processing
4306f037-e67a-4ff1-a86c-5749b7266398	4306f037-e67a-4ff1-a86c-5749b7266398	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/520c2826-35a3-4029-9a9e-bba26230db47_1750141113597_Call recording Vikas Alagarsamy_250616_101058.m4a	Processing...	0.00	en	2025-06-17 11:48:33.598+05:30	2025-06-17 11:48:33.606+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
46608537-d1e3-4d57-94fa-5fee9842655f	46608537-d1e3-4d57-94fa-5fee9842655f	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/492795f5-791d-44c4-b6a1-00d20c04cb88_1750141113830_Call recording Vikas Alagarsamy_250616_101638.m4a	Processing...	0.00	en	2025-06-17 11:48:33.831+05:30	2025-06-17 11:48:33.833+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
1e415c97-de25-49c7-a15c-5f12347a108e	1e415c97-de25-49c7-a15c-5f12347a108e	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/894feedd-a841-4c39-909b-29171c32f645_1750141115590_Call recording Vikas Alagarsamy_250616_102626.m4a	Processing...	0.00	en	2025-06-17 11:48:35.594+05:30	2025-06-17 11:48:35.595+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
37f35e97-eb28-4b07-9806-bf9bcb51f878	37f35e97-eb28-4b07-9806-bf9bcb51f878	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/ea10bf07-d23c-478f-8bcf-1b6da64d38dc_1750141116086_Call recording Vikas Alagarsamy_250616_102626.m4a	Processing...	0.00	en	2025-06-17 11:48:36.086+05:30	2025-06-17 11:48:36.088+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
d683ece2-9894-42ac-bf54-e17ce31452fe	mobile_EMP001_9999999999_1750082151605	\N	\N	Test Real-Time Call	EMP001	9999999999	0	\N	outgoing call ringing	1.00	en	2025-06-16 19:25:51.605+05:30	2025-06-16 19:25:51.605+05:30	\N	processing	Direction: outgoing	outgoing	ringing
b3a361d7-ad67-4b8e-afe6-0732dee8925c	mobile_EMP001_9876543210	\N	\N	Active Call Demo	EMP001	9876543210	0	\N	outgoing call connected	1.00	en	2025-06-16 06:47:00+05:30	2025-06-16 07:26:19.643+05:30	\N	processing	Direction: outgoing	outgoing	connected
c30fe5ae-53a5-4460-975c-b3fa7b7b9b90	mobile_EMP001_7358498287	\N	\N	Mobile Call - 7358498287	EMP001	7358498287	115	\N	outgoing call completed successfully	1.00	en	2025-06-16 09:52:50.883+05:30	2025-06-16 09:54:45.509+05:30	\N	completed	Direction: outgoing	outgoing	completed
978941ef-8c66-4b61-87f6-859200c67eed	mobile_EMP001_919876543210_1750082709814	\N	\N	Real-Time Test Call	EMP001	+919876543210	0	\N	outgoing call completed successfully	1.00	en	2025-06-16 19:35:09.772+05:30	2025-06-16 19:35:14.868+05:30	\N	completed	Direction: outgoing	outgoing	completed
2bcf4fcb-5d52-47c3-8ab4-33ca52af946c	2bcf4fcb-5d52-47c3-8ab4-33ca52af946c	\N	\N	Test Contact	Employee EMP-25-0001	9999999999	60	http://localhost:3000/api/call-recordings/file/android_EMP-25-0001_1750122761249.mp3	Processing failed: Translation failed: Command failed: source whisper-env/bin/activate && python "/Users/vikasalagarsamy/OOAK-FUTURE/scripts/faster-whisper-translate.py" "/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/android_EMP-25-0001_1750122761249.mp3" "large-v3"\n	0.00	en	2025-06-17 06:41:40.451+05:30	2025-06-17 06:42:41.251+05:30	unknown	error	Android upload from device aef21d11c36e3b2e. Direction: outgoing	outgoing	processing
7b5740e3-8a7b-4084-abaa-926d598b3b7b	7b5740e3-8a7b-4084-abaa-926d598b3b7b	\N	\N	Test Contact	Employee EMP-25-0001	9999999999	60	http://localhost:3000/api/call-recordings/file/android_EMP-25-0001_1750124651950.mp3	Processing failed: Translation failed: Command failed: source whisper-env/bin/activate && python "/Users/vikasalagarsamy/OOAK-FUTURE/scripts/faster-whisper-translate.py" "/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/android_EMP-25-0001_1750124651950.mp3" "large-v3"\n	0.00	en	2025-06-17 07:13:11.774+05:30	2025-06-17 07:14:11.951+05:30	unknown	error	Android upload from device aef21d11c36e3b2e. Direction: outgoing	outgoing	processing
c3a980f8-f538-45e2-a9e8-2aff54c412bf	c3a980f8-f538-45e2-a9e8-2aff54c412bf	\N	\N	Test Contact	Employee EMP-25-0001	9999999999	60	http://localhost:3000/api/call-recordings/file/android_EMP-25-0001_1750124678781.mp3	Processing failed: Translation failed: Command failed: source whisper-env/bin/activate && python "/Users/vikasalagarsamy/OOAK-FUTURE/scripts/faster-whisper-translate.py" "/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/android_EMP-25-0001_1750124678781.mp3" "large-v3"\n	0.00	en	2025-06-17 07:13:38.527+05:30	2025-06-17 07:14:38.782+05:30	unknown	error	Android upload from device aef21d11c36e3b2e. Direction: outgoing	outgoing	processing
97756a90-edc3-42f9-9797-563d1ec3fb2c	97756a90-edc3-42f9-9797-563d1ec3fb2c	\N	\N	Test Contact	Employee EMP-25-0001	9999999999	60	https://portal.ooak.photography/api/call-recordings/file/android_EMP-25-0001_1750130635773.mp3	Processing failed: Translation failed: Command failed: source whisper-env/bin/activate && python "/Users/vikasalagarsamy/OOAK-FUTURE/scripts/faster-whisper-translate.py" "/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/android_EMP-25-0001_1750130635773.mp3" "large-v3"\n	0.00	en	2025-06-17 08:52:55.237+05:30	2025-06-17 08:53:55.774+05:30	unknown	error	Android upload from device aef21d11c36e3b2e. Direction: outgoing	outgoing	processing
4d0fe8cc-ad14-43e2-990d-00e75ed4e641	4d0fe8cc-ad14-43e2-990d-00e75ed4e641	\N	\N	Vikas Alagarsamy	Employee EMP-25-0001	+919677362524	10	https://portal.ooak.photography/api/call-recordings/file/android_EMP-25-0001_1750132798134.m4a	Processing...	0.00	en	2025-06-17 09:12:48+05:30	2025-06-17 09:29:58.135+05:30	unknown	transcribing	Android upload from device manual_upload_latest. Direction: outgoing	outgoing	processing
b09acade-83a7-4406-b783-8c39edd56878	b09acade-83a7-4406-b783-8c39edd56878	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/e5ed7188-121a-4766-8d64-076473eff11f_1750141113676_Call recording Vikas Alagarsamy_250616_101058.m4a	Processing...	0.00	en	2025-06-17 11:48:33.677+05:30	2025-06-17 11:48:33.677+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
7bcf0dc5-5923-495d-811e-f3c892f76c05	mobile_EMP001_9677362524	\N	\N	Mobile Call - 9677362524	EMP001	9677362524	11	\N	Unanswered call - agent called but client did not answer	1.00	en	2025-06-16 09:55:02.941+05:30	2025-06-16 12:22:46.472+05:30	\N	completed	Direction: outgoing	outgoing	unanswered
b1638ea6-80f9-4795-b11e-5ef8282180fe	mobile_EMP001_919677362524	\N	\N	Test Call	EMP001	+919677362524	12	\N	outgoing call ringing	1.00	en	2025-06-16 07:28:16.437+05:30	2025-06-16 12:32:44.743+05:30	\N	processing	Direction: outgoing	incoming	ringing
fc44e5ff-ffb6-4cee-a558-4e75dc4dcf40	mobile_EMP001_919677362524_1750057538078	\N	\N	Test Real-Time Call	EMP001	+919677362524	12	\N	outgoing call completed successfully	1.00	en	2025-06-16 12:35:38.078+05:30	2025-06-16 12:35:38.078+05:30	\N	completed	Direction: outgoing	outgoing	completed
b0296740-b80a-45da-a605-7464e72270f7	mobile_EMP001_7358144070_1750057741744	\N	\N	Mobile Call - 7358144070	EMP001	7358144070	0	\N	outgoing call connected	1.00	en	2025-06-16 12:39:01.71+05:30	2025-06-16 12:39:01.744+05:30	\N	processing	Direction: outgoing	outgoing	connected
67d3fcc0-3225-4458-8380-2824795aff86	mobile_EMP001_919677362524_1750058387330	\N	\N	Test Dynamic Call	EMP001	+919677362524	7	\N	Missed call - client called but agent did not answer	1.00	en	2025-06-16 12:49:47.33+05:30	2025-06-16 12:49:56.418+05:30	\N	completed	Direction: incoming	incoming	missed
52e58af9-bd5a-4fc8-9977-d53f66b9f7c1	mobile_EMP001_919677362524_1750058491480	\N	\N	Mobile Call - +919677362524	EMP001	+919677362524	6	\N	Unanswered call - agent called but client did not answer	1.00	en	2025-06-16 12:51:31.455+05:30	2025-06-16 12:52:24.975+05:30	\N	completed	Direction: incoming	incoming	unanswered
0887f2d4-2a86-4841-bfbb-107053357f37	0887f2d4-2a86-4841-bfbb-107053357f37	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/6208f0ba-05b8-41ff-8e34-1801cd4e97d6_1750141116122_Call recording Vikas Alagarsamy_250616_101917.m4a	Processing...	0.00	en	2025-06-17 11:48:36.122+05:30	2025-06-17 11:48:36.124+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
5bfab1b5-bb9d-4153-b286-4eca5ba3df1d	5bfab1b5-bb9d-4153-b286-4eca5ba3df1d	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/cbdc959a-4275-4d46-86b5-aaf5718c398b_1750141117113_Call recording Vikas Alagarsamy_250616_104416.m4a	Processing...	0.00	en	2025-06-17 11:48:37.113+05:30	2025-06-17 11:48:37.118+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
e92a8f4f-2547-49d5-9459-b767f583e29f	e92a8f4f-2547-49d5-9459-b767f583e29f	\N	\N	Call with 8825912420	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/03477f1e-2cd0-471c-ae9c-10aa2c1a9430_1750141123672_Call recording 8825912420_250616_115116.m4a	Processing...	0.00	en	2025-06-17 11:48:43.673+05:30	2025-06-17 11:48:43.679+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: 8825912420	outgoing	processing
40430e65-b1c7-49eb-a358-a7b1b37f24cd	40430e65-b1c7-49eb-a358-a7b1b37f24cd	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/c2760b09-e471-4deb-893a-3237e20cffdb_1750141116392_Call recording Vikas Alagarsamy_250616_104416.m4a	Processing...	0.00	en	2025-06-17 11:48:36.392+05:30	2025-06-17 11:48:36.395+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
1556c691-0024-4a22-bc18-ef25222ac962	1556c691-0024-4a22-bc18-ef25222ac962	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/c6e3091b-aede-4c07-95e8-c45ca4c87899_1750141116843_Call recording Vikas Alagarsamy_250616_105541.m4a	Processing...	0.00	en	2025-06-17 11:48:36.846+05:30	2025-06-17 11:48:36.848+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
41dbe7c7-eae2-4d3a-aec7-a9b2c4af969e	41dbe7c7-eae2-4d3a-aec7-a9b2c4af969e	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/b44df7d3-81fe-4062-a24b-e0cf4027b9c0_1750141117409_Call recording Vikas Alagarsamy_250616_110108.m4a	Processing...	0.00	en	2025-06-17 11:48:37.41+05:30	2025-06-17 11:48:37.412+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
dd32ef17-e0e1-41ee-9347-8e1a333599d6	dd32ef17-e0e1-41ee-9347-8e1a333599d6	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/e52c80b8-bc17-4827-a02e-d98a47412f71_1750141117761_Call recording Vikas Alagarsamy_250616_110647.m4a	Processing...	0.00	en	2025-06-17 11:48:37.778+05:30	2025-06-17 11:48:37.782+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
92c677e2-ed75-468c-ac58-98500b1e108f	92c677e2-ed75-468c-ac58-98500b1e108f	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/bd52b96c-fb18-4122-baed-c6fe63482e7c_1750141122709_Call recording Vikas Alagarsamy_250616_114840.m4a	Processing...	0.00	en	2025-06-17 11:48:42.71+05:30	2025-06-17 11:48:42.715+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
e9146b56-39da-4a9d-acbc-89a465ea2d66	e9146b56-39da-4a9d-acbc-89a465ea2d66	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/a22ed98b-4607-4e3b-9890-fbaf6f999c9a_1750141116862_Call recording Vikas Alagarsamy_250616_104950.m4a	Processing...	0.00	en	2025-06-17 11:48:36.863+05:30	2025-06-17 11:48:36.864+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
b4c12159-1736-4aa8-9924-617d5e9445c7	b4c12159-1736-4aa8-9924-617d5e9445c7	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/c10922e6-d105-4a48-9d3c-e5893dcdcf7a_1750141117933_Call recording Vikas Alagarsamy_250616_105541.m4a	Processing...	0.00	en	2025-06-17 11:48:37.938+05:30	2025-06-17 11:48:37.944+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
cb9fe46c-6fe0-4347-9028-5e836b682014	cb9fe46c-6fe0-4347-9028-5e836b682014	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/4bc4d5bb-7fba-4028-af76-6dade7e11075_1750141122747_Call recording Vikas Alagarsamy_250616_120507.m4a	Processing...	0.00	en	2025-06-17 11:48:42.778+05:30	2025-06-17 11:48:42.782+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
39077a6c-82c8-426e-b9bd-86aab35664be	39077a6c-82c8-426e-b9bd-86aab35664be	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/683a35d8-0d62-41f8-857c-6d312d6c7dce_1750141116960_Call recording Vikas Alagarsamy_250616_104950.m4a	Processing...	0.00	en	2025-06-17 11:48:36.965+05:30	2025-06-17 11:48:36.968+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
379632b7-1bfd-40fc-afeb-f173bf45f022	379632b7-1bfd-40fc-afeb-f173bf45f022	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/e7d6d675-138b-408c-b560-5cc86582b963_1750141118228_Call recording Vikas Alagarsamy_250616_112754.m4a	Processing...	0.00	en	2025-06-17 11:48:38.235+05:30	2025-06-17 11:48:38.239+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
d814284d-eb37-4c72-983f-5d607976b2e9	d814284d-eb37-4c72-983f-5d607976b2e9	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/f92974c6-5de0-4523-b16c-35fec67b182b_1750141119791_Call recording Vikas Alagarsamy_250616_114840.m4a	Processing...	0.00	en	2025-06-17 11:48:39.793+05:30	2025-06-17 11:48:39.795+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
766f22a7-8627-4b27-987d-e60d4bbde1e8	766f22a7-8627-4b27-987d-e60d4bbde1e8	\N	\N	Call with 8825912420	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/ad1e12e0-987a-4b22-a253-bce4a5714afa_1750141130254_Call recording 8825912420_250616_115116.m4a	Processing...	0.00	en	2025-06-17 11:48:50.256+05:30	2025-06-17 11:48:50.269+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: 8825912420	outgoing	processing
82bbc81d-6583-4a75-b3ca-734e073a04fc	82bbc81d-6583-4a75-b3ca-734e073a04fc	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/a1c43115-ee17-4542-b450-c91c70fbad59_1750141118542_Call recording Vikas Alagarsamy_250616_110108.m4a	Processing...	0.00	en	2025-06-17 11:48:38.543+05:30	2025-06-17 11:48:38.548+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
33616599-9436-4ae2-96cb-63cc857d92d2	33616599-9436-4ae2-96cb-63cc857d92d2	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/3aeb0ccb-678a-4dbb-9f68-499a15b5a687_1750141121603_Call recording Vikas Alagarsamy_250616_114358.m4a	Processing...	0.00	en	2025-06-17 11:48:41.613+05:30	2025-06-17 11:48:41.621+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
283b6a29-7810-4084-83b7-f63aed3980fd	283b6a29-7810-4084-83b7-f63aed3980fd	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/69b2e189-9bb8-44a4-a79c-a571f45343fd_1750141132144_Call recording Vikas Alagarsamy_250616_120507.m4a	Processing...	0.00	en	2025-06-17 11:48:52.158+05:30	2025-06-17 11:48:52.186+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
1f993da2-f29f-4880-87e8-d7bf677a899d	1f993da2-f29f-4880-87e8-d7bf677a899d	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/965b913a-0e19-45a7-b9ee-05f741545298_1750141119064_Call recording Vikas Alagarsamy_250616_114358.m4a	Processing...	0.00	en	2025-06-17 11:48:39.068+05:30	2025-06-17 11:48:39.072+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
c6c8fed8-92d7-43b9-bc62-0aa65aa97779	c6c8fed8-92d7-43b9-bc62-0aa65aa97779	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/6735764c-a93f-47cb-887c-48ae180215b9_1750141132207_Call recording Vikas Alagarsamy_250616_123832.m4a	Processing...	0.00	en	2025-06-17 11:48:52.269+05:30	2025-06-17 11:48:52.29+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
7463aa1a-2b93-46ee-9271-3034b334a7b5	7463aa1a-2b93-46ee-9271-3034b334a7b5	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/0a6286da-70c3-4dde-9ea3-8fbb66e79989_1750141119204_Call recording Vikas Alagarsamy_250616_110647.m4a	Processing...	0.00	en	2025-06-17 11:48:39.207+05:30	2025-06-17 11:48:39.21+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
d4678d2d-fc7a-4b72-96be-bb42ec86cecf	d4678d2d-fc7a-4b72-96be-bb42ec86cecf	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/6c564210-2237-4d57-bdf7-43b2cb6d4467_1750141129834_Call recording Vikas Alagarsamy_250616_122214.m4a	Processing...	0.00	en	2025-06-17 11:48:49.841+05:30	2025-06-17 11:48:49.853+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
98fcb9cf-6af3-4b73-a28c-a0f90f7694f5	98fcb9cf-6af3-4b73-a28c-a0f90f7694f5	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/0fa7204e-d2e7-4c57-ae8f-ea182b279986_1750141119545_Call recording Vikas Alagarsamy_250616_112754.m4a	Processing...	0.00	en	2025-06-17 11:48:39.547+05:30	2025-06-17 11:48:39.55+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
cb079609-7b80-462c-ab6e-66f55a3de637	cb079609-7b80-462c-ab6e-66f55a3de637	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/2e720fe6-159b-41b5-bd26-2412d972ade9_1750141130108_Call recording Vikas Alagarsamy_250616_122239.m4a	Processing...	0.00	en	2025-06-17 11:48:50.118+05:30	2025-06-17 11:48:50.139+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
5fd04169-5ebb-4519-979a-8e4be6e7a1ea	5fd04169-5ebb-4519-979a-8e4be6e7a1ea	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/00d5ff52-2af2-43c4-8d32-5c5e790c9132_1750141123441_Call recording Vikas Alagarsamy_250616_121100.m4a	Processing...	0.00	en	2025-06-17 11:48:43.448+05:30	2025-06-17 11:48:43.456+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
3ae85b1e-2e13-445f-9f6a-da68538e0713	3ae85b1e-2e13-445f-9f6a-da68538e0713	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/08e677c7-644a-42b1-a0cf-d08e7b045782_1750141138869_Call recording Vikas Alagarsamy_250616_121100.m4a	Processing...	0.00	en	2025-06-17 11:48:58.883+05:30	2025-06-17 11:48:58.918+05:30	\N	processing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
7e90059b-17d1-4fd2-80e8-c6c3856c6660	7e90059b-17d1-4fd2-80e8-c6c3856c6660	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/5530c53d-1804-41f3-a9d5-028df2bc13cb_1750141894430_Call recording Vikas Alagarsamy_250616_101638.m4a	Processing...	0.00	en	2025-06-17 12:01:34.431+05:30	2025-06-17 12:01:34.434+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
7da774a5-9723-490e-8478-377e1778a7b3	7da774a5-9723-490e-8478-377e1778a7b3	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/c346da20-3935-4da8-b129-b5f6e28bc29d_1750141895582_Call recording Vikas Alagarsamy_250616_100915.m4a	Processing...	0.00	en	2025-06-17 12:01:35.583+05:30	2025-06-17 12:01:35.586+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
e9c7f8f1-4eef-4204-bf9b-33f172e55458	e9c7f8f1-4eef-4204-bf9b-33f172e55458	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/38c72c2e-d956-40f6-9281-64dc74523133_1750141896495_Call recording Vikas Alagarsamy_250616_101058.m4a	Processing...	0.00	en	2025-06-17 12:01:36.495+05:30	2025-06-17 12:01:36.497+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
6b38f766-13ff-4f07-9b7d-c2fe61fb8231	6b38f766-13ff-4f07-9b7d-c2fe61fb8231	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/7a1c333b-7b77-46c8-a173-02beebac4f07_1750141899583_Call recording Vikas Alagarsamy_250616_101058.m4a	Processing...	0.00	en	2025-06-17 12:01:39.583+05:30	2025-06-17 12:01:39.584+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
4e8128c9-e9a6-4ba1-8e11-c54d3a83a9f2	4e8128c9-e9a6-4ba1-8e11-c54d3a83a9f2	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/64795b85-ec55-48a9-a385-d59573caa8f6_1750141900273_Call recording Vikas Alagarsamy_250616_100915.m4a	Processing...	0.00	en	2025-06-17 12:01:40.274+05:30	2025-06-17 12:01:40.275+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
cd4252e6-667d-420a-b214-002a56eeb226	cd4252e6-667d-420a-b214-002a56eeb226	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/2192b1c9-a129-4b7c-96f0-b4e3215880a3_1750141900682_Call recording Vikas Alagarsamy_250616_101917.m4a	Processing...	0.00	en	2025-06-17 12:01:40.683+05:30	2025-06-17 12:01:40.685+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
5f9a47a5-4802-4349-aa2a-a94f6ce78a43	5f9a47a5-4802-4349-aa2a-a94f6ce78a43	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/e55112a7-3b3f-4070-8a18-61852a206ff8_1750141900996_Call recording Vikas Alagarsamy_250616_101917.m4a	Processing...	0.00	en	2025-06-17 12:01:40.997+05:30	2025-06-17 12:01:40.999+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
d0b633be-a1ec-4ed0-9cfc-0eb539297f0c	d0b633be-a1ec-4ed0-9cfc-0eb539297f0c	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/1f5f1b57-72f6-439e-8ce8-096b38f98bf6_1750141901416_Call recording Vikas Alagarsamy_250616_101638.m4a	Processing...	0.00	en	2025-06-17 12:01:41.418+05:30	2025-06-17 12:01:41.42+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
7b6f2871-4e13-4cfd-becb-b362ce5b099c	7b6f2871-4e13-4cfd-becb-b362ce5b099c	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/10ad2848-3bd6-4c38-8cb2-adf54add0f10_1750141901742_Call recording Vikas Alagarsamy_250616_102626.m4a	Processing...	0.00	en	2025-06-17 12:01:41.742+05:30	2025-06-17 12:01:41.745+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
80ad3180-e5c4-40ca-9f0b-ca405a48702b	80ad3180-e5c4-40ca-9f0b-ca405a48702b	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/03354aeb-37a4-4ce8-a03c-fbd5f65f5ffb_1750141901901_Call recording Vikas Alagarsamy_250616_102626.m4a	Processing...	0.00	en	2025-06-17 12:01:41.902+05:30	2025-06-17 12:01:41.903+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
0b27a44f-0f13-473b-8c43-0c0c1b68ef33	0b27a44f-0f13-473b-8c43-0c0c1b68ef33	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/8ba97f10-756e-4a89-bb2a-e6906556c58b_1750141902180_Call recording Vikas Alagarsamy_250616_104416.m4a	Processing...	0.00	en	2025-06-17 12:01:42.181+05:30	2025-06-17 12:01:42.183+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
535bca55-f34b-48ce-8f51-501023aad78b	535bca55-f34b-48ce-8f51-501023aad78b	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/f4d302e2-b311-417e-9b90-b45b79de3654_1750141902815_Call recording Vikas Alagarsamy_250616_104416.m4a	Processing...	0.00	en	2025-06-17 12:01:42.816+05:30	2025-06-17 12:01:42.818+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
0b1d4731-c408-4d99-8484-bf355fb54534	0b1d4731-c408-4d99-8484-bf355fb54534	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/8c0c46ac-90f2-493e-888d-ebe4660cae4a_1750141903879_Call recording Vikas Alagarsamy_250616_104950.m4a	Processing...	0.00	en	2025-06-17 12:01:43.879+05:30	2025-06-17 12:01:43.882+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
fdddf535-f7b2-4373-8900-9b70f6fa4b7d	fdddf535-f7b2-4373-8900-9b70f6fa4b7d	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/a214bd6c-3015-4b16-85d2-22dcad845426_1750141904782_Call recording Vikas Alagarsamy_250616_104950.m4a	Processing...	0.00	en	2025-06-17 12:01:44.782+05:30	2025-06-17 12:01:44.783+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
27a623ec-ba46-4517-b4af-99707f248a1b	27a623ec-ba46-4517-b4af-99707f248a1b	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/20611cd6-0649-4bed-8779-886812113609_1750141905172_Call recording Vikas Alagarsamy_250616_105541.m4a	Processing...	0.00	en	2025-06-17 12:01:45.172+05:30	2025-06-17 12:01:45.174+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
5c55657f-ed5e-4a28-9a61-ac6eb3a09beb	5c55657f-ed5e-4a28-9a61-ac6eb3a09beb	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/3fd875ee-444e-4ec3-9a04-f807f7ec64f3_1750141905572_Call recording Vikas Alagarsamy_250616_105541.m4a	Processing...	0.00	en	2025-06-17 12:01:45.572+05:30	2025-06-17 12:01:45.575+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
8390666f-b019-412c-a2e2-09611a9b1c12	8390666f-b019-412c-a2e2-09611a9b1c12	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/a081545c-9bb4-4413-a68f-46dc16edfa5c_1750141907682_Call recording Vikas Alagarsamy_250616_110108.m4a	Processing...	0.00	en	2025-06-17 12:01:47.689+05:30	2025-06-17 12:01:47.692+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
3d8f39d2-69a6-46d0-b697-5d0a416bfa96	3d8f39d2-69a6-46d0-b697-5d0a416bfa96	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/42ede75e-1fe2-46cc-b7b8-cbcf929a7342_1750141907682_Call recording Vikas Alagarsamy_250616_110108.m4a	Processing...	0.00	en	2025-06-17 12:01:47.684+05:30	2025-06-17 12:01:47.722+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
2f4c6dbc-389e-4af0-8b49-0877801bfeb8	2f4c6dbc-389e-4af0-8b49-0877801bfeb8	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/c2f8ce9b-2ad8-44e2-b82a-2e1638f6834e_1750141907849_Call recording Vikas Alagarsamy_250616_110647.m4a	Processing...	0.00	en	2025-06-17 12:01:47.849+05:30	2025-06-17 12:01:47.85+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
83554696-0e6e-476d-b603-5ca721596148	83554696-0e6e-476d-b603-5ca721596148	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/e00fd337-1221-4cf1-beaa-8c7e2d083c19_1750141907992_Call recording Vikas Alagarsamy_250616_112754.m4a	Processing...	0.00	en	2025-06-17 12:01:47.992+05:30	2025-06-17 12:01:47.993+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
67013fda-3389-4ba6-81c0-430972175445	67013fda-3389-4ba6-81c0-430972175445	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/2b6f3875-668c-4b14-818a-080d41992d8e_1750141909017_Call recording Vikas Alagarsamy_250616_112754.m4a	Processing...	0.00	en	2025-06-17 12:01:49.02+05:30	2025-06-17 12:01:49.013+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
96bfbd40-2fe0-4ec8-8475-1c1edaa33f76	96bfbd40-2fe0-4ec8-8475-1c1edaa33f76	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/a050496f-cf20-4324-b388-58d6787ad97a_1750141909840_Call recording Vikas Alagarsamy_250616_114358.m4a	Processing...	0.00	en	2025-06-17 12:01:49.841+05:30	2025-06-17 12:01:49.838+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
8e939bf0-3402-4fbf-b5b8-6bee12cfae2e	8e939bf0-3402-4fbf-b5b8-6bee12cfae2e	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/46e883e7-86b1-4b4d-a21e-d5f1a799030f_1750141910049_Call recording Vikas Alagarsamy_250616_114840.m4a	Processing...	0.00	en	2025-06-17 12:01:50.05+05:30	2025-06-17 12:01:50.044+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
4247e649-ad07-4243-9def-e65399819e06	4247e649-ad07-4243-9def-e65399819e06	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/728ffaa1-d014-48bc-a8eb-57721048d6c4_1750141910529_Call recording Vikas Alagarsamy_250616_114840.m4a	Processing...	0.00	en	2025-06-17 12:01:50.53+05:30	2025-06-17 12:01:50.526+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
5d3bba0c-ccf0-4eba-a065-ef51d7564ca6	5d3bba0c-ccf0-4eba-a065-ef51d7564ca6	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/022a6456-6d71-4041-951e-d26ee4c95adf_1750141913334_Call recording Vikas Alagarsamy_250616_120507.m4a	Processing...	0.00	en	2025-06-17 12:01:53.337+05:30	2025-06-17 12:01:53.337+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
c556518a-1fc0-419a-b95a-8163f771fdd1	c556518a-1fc0-419a-b95a-8163f771fdd1	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/9f341b88-4167-4f6b-8491-9c49eb5cfe1d_1750141915506_Call recording Vikas Alagarsamy_250616_123832.m4a	Processing...	0.00	en	2025-06-17 12:01:55.51+05:30	2025-06-17 12:01:55.503+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
16562e28-e5fc-4ec8-b931-0e274cf34f8f	16562e28-e5fc-4ec8-b931-0e274cf34f8f	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/ee318deb-fde6-4231-85d1-50e8e3ea9408_1750141915543_Call recording Vikas Alagarsamy_250616_123832.m4a	Processing...	0.00	en	2025-06-17 12:01:55.544+05:30	2025-06-17 12:01:55.541+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
c1eb7a12-69ec-4e9e-ab18-fa0ee1af4ac0	c1eb7a12-69ec-4e9e-ab18-fa0ee1af4ac0	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/2b5ed4fa-de4a-4496-b945-2f0f0bef6d88_1750141915785_Call recording Vikas Alagarsamy_250616_125204.m4a	Processing...	0.00	en	2025-06-17 12:01:55.788+05:30	2025-06-17 12:01:55.782+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
58d562fe-b39d-4d87-a018-ef67b4fb6269	58d562fe-b39d-4d87-a018-ef67b4fb6269	\N	\N	Call with 7358144070	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/00be8760-3412-40f5-98a4-d05ee90e00af_1750141916341_Call recording 7358144070_250616_143003.m4a	Processing...	0.00	en	2025-06-17 12:01:56.345+05:30	2025-06-17 12:01:56.341+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: 7358144070	outgoing	processing
69802b55-9e7c-4257-be47-4ecc858d57b7	69802b55-9e7c-4257-be47-4ecc858d57b7	\N	\N	Call with 7358144070	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/5fc97480-e957-4634-b5bc-8e921a3b6bba_1750141917140_Call recording 7358144070_250616_143003.m4a	Processing...	0.00	en	2025-06-17 12:01:57.154+05:30	2025-06-17 12:01:57.15+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: 7358144070	outgoing	processing
9ce404c2-2c34-4362-93b4-e578640793a2	9ce404c2-2c34-4362-93b4-e578640793a2	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/ec7a6011-cfcc-4af4-b799-26fe1d127a6e_1750141917300_Call recording Vikas Alagarsamy_250616_190444.m4a	Processing...	0.00	en	2025-06-17 12:01:57.301+05:30	2025-06-17 12:01:57.295+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
6aa15df2-0a69-4e67-b658-1de3ee2a3c48	6aa15df2-0a69-4e67-b658-1de3ee2a3c48	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/17cceef9-8477-4542-9458-54f1423b16cf_1750141928562_Call recording Vikas Alagarsamy_250616_193112.m4a	Processing...	0.00	en	2025-06-17 12:02:08.565+05:30	2025-06-17 12:02:09.243+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
8de0c580-7d63-4da1-a0a1-d351e319f452	8de0c580-7d63-4da1-a0a1-d351e319f452	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/ed55255b-ebbc-4b34-affc-00e7fd3b64be_1750141928562_Call recording Vikas Alagarsamy_250616_192214.m4a	Processing...	0.00	en	2025-06-17 12:02:08.569+05:30	2025-06-17 12:02:09.258+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
bc8839a2-8a82-4c35-b35a-9c8e49ee022d	bc8839a2-8a82-4c35-b35a-9c8e49ee022d	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/c4c77198-e538-40e0-a7c1-4babb83250ea_1750141907843_Call recording Vikas Alagarsamy_250616_110647.m4a	Processing...	0.00	en	2025-06-17 12:01:47.846+05:30	2025-06-17 12:01:47.85+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
ff696b23-d0e9-4caf-9cdc-94c760c5c416	ff696b23-d0e9-4caf-9cdc-94c760c5c416	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/05b19e39-212a-4ac4-9449-66f525d1cdb8_1750141910528_Call recording Vikas Alagarsamy_250616_114358.m4a	Processing...	0.00	en	2025-06-17 12:01:50.529+05:30	2025-06-17 12:01:50.526+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
6d43fb9d-6188-4c4b-99d5-27becad2b36d	6d43fb9d-6188-4c4b-99d5-27becad2b36d	\N	\N	Call with 8825912420	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/31ba4c6a-cb25-4380-9438-b414f4613cbe_1750141911737_Call recording 8825912420_250616_115116.m4a	Processing...	0.00	en	2025-06-17 12:01:51.739+05:30	2025-06-17 12:01:51.733+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: 8825912420	outgoing	processing
9f657ea4-7136-4289-b698-c2e7630ae753	9f657ea4-7136-4289-b698-c2e7630ae753	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/d9fa9268-56ca-436c-bba9-b75a268c1d30_1750141912335_Call recording Vikas Alagarsamy_250616_120507.m4a	Processing...	0.00	en	2025-06-17 12:01:52.342+05:30	2025-06-17 12:01:52.337+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
5ccc6ba6-7945-4d68-a9d8-8c96b5d78680	5ccc6ba6-7945-4d68-a9d8-8c96b5d78680	\N	\N	Call with 8825912420	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/f98f5901-550e-4a12-af26-cb9841f3e484_1750141912362_Call recording 8825912420_250616_115116.m4a	Processing...	0.00	en	2025-06-17 12:01:52.363+05:30	2025-06-17 12:01:52.356+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: 8825912420	outgoing	processing
7571a4dc-7b2b-451c-9652-e4be30e9c00c	7571a4dc-7b2b-451c-9652-e4be30e9c00c	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/906db1e2-17bd-4325-9dfd-14c12620c0cd_1750141913322_Call recording Vikas Alagarsamy_250616_121100.m4a	Processing...	0.00	en	2025-06-17 12:01:53.328+05:30	2025-06-17 12:01:53.326+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
cd131127-1068-4c44-ad1e-0e5a879dfb71	cd131127-1068-4c44-ad1e-0e5a879dfb71	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/cff70c80-fb4d-4c38-8869-7c411f752bb7_1750141914114_Call recording Vikas Alagarsamy_250616_121100.m4a	Processing...	0.00	en	2025-06-17 12:01:54.118+05:30	2025-06-17 12:01:54.123+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
2d833161-b1ee-4363-b955-d0ec1d4c4bd3	2d833161-b1ee-4363-b955-d0ec1d4c4bd3	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/1249d969-7262-4508-a9ab-39de538b1817_1750141914458_Call recording Vikas Alagarsamy_250616_122214.m4a	Processing...	0.00	en	2025-06-17 12:01:54.46+05:30	2025-06-17 12:01:54.455+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
e9f6582e-5beb-4815-9a42-208e8079dfdc	e9f6582e-5beb-4815-9a42-208e8079dfdc	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/be8e1134-2c86-4b64-8b17-02373608fac3_1750141914862_Call recording Vikas Alagarsamy_250616_122214.m4a	Processing...	0.00	en	2025-06-17 12:01:54.864+05:30	2025-06-17 12:01:54.86+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
44d767e0-1dc7-4a70-a7b8-610bdda9edc4	44d767e0-1dc7-4a70-a7b8-610bdda9edc4	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/e34826c2-415d-481a-a841-20e5d1f97738_1750141915057_Call recording Vikas Alagarsamy_250616_122239.m4a	Processing...	0.00	en	2025-06-17 12:01:55.059+05:30	2025-06-17 12:01:55.054+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
df9325e6-cacb-4abc-890e-eaa7d01d68b6	df9325e6-cacb-4abc-890e-eaa7d01d68b6	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/823e1273-c0f1-4e3d-bff3-b7500cc29fb3_1750141915085_Call recording Vikas Alagarsamy_250616_122239.m4a	Processing...	0.00	en	2025-06-17 12:01:55.088+05:30	2025-06-17 12:01:55.083+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
ca0c0390-c283-491e-a3b2-e2305bf82643	ca0c0390-c283-491e-a3b2-e2305bf82643	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/be053af1-884a-483e-8146-29b8997da36f_1750141915790_Call recording Vikas Alagarsamy_250616_125204.m4a	Processing...	0.00	en	2025-06-17 12:01:55.792+05:30	2025-06-17 12:01:55.787+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
8c7f10df-25a1-4db1-9993-16360ecf7013	8c7f10df-25a1-4db1-9993-16360ecf7013	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/01bbf837-ddc9-486a-b607-a436056f694a_1750141917161_Call recording Vikas Alagarsamy_250616_190444.m4a	Processing...	0.00	en	2025-06-17 12:01:57.163+05:30	2025-06-17 12:01:57.158+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
13ceed25-9c11-47e9-9274-1ce615a50d53	13ceed25-9c11-47e9-9274-1ce615a50d53	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/fb67cb25-ccb9-4d7c-a604-f2d49975a2c9_1750141928561_Call recording Vikas Alagarsamy_250616_190652.m4a	Processing...	0.00	en	2025-06-17 12:02:08.574+05:30	2025-06-17 12:02:09.266+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
f8de1897-0e71-4413-8633-273f814de50f	f8de1897-0e71-4413-8633-273f814de50f	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/419040d2-f3e5-425f-a350-06380d2ae942_1750141928561_Call recording Vikas Alagarsamy_250616_192214.m4a	Processing...	0.00	en	2025-06-17 12:02:08.567+05:30	2025-06-17 12:02:09.333+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
ee625bc4-20f7-4468-ba30-3ca41ea92442	ee625bc4-20f7-4468-ba30-3ca41ea92442	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/25de4b80-67f7-4c1f-a8a4-8599b62c4127_1750141928563_Call recording Vikas Alagarsamy_250616_190652.m4a	Processing...	0.00	en	2025-06-17 12:02:08.571+05:30	2025-06-17 12:02:09.333+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
ad840062-a850-4814-b98c-27bd1ba38218	ad840062-a850-4814-b98c-27bd1ba38218	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/64c867ac-8392-4026-b801-e88bf2236a7f_1750141930651_Call recording Vikas Alagarsamy_250617_063053.m4a	Processing...	0.00	en	2025-06-17 12:02:10.651+05:30	2025-06-17 12:02:10.647+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
febe76b3-0fca-475f-8ae0-a343e269b0f6	febe76b3-0fca-475f-8ae0-a343e269b0f6	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/86592678-f9eb-4441-8b49-40253b1248eb_1750141930902_Call recording Vikas Alagarsamy_250616_193112.m4a	Processing...	0.00	en	2025-06-17 12:02:10.903+05:30	2025-06-17 12:02:10.972+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
0cd20caf-c4d0-4126-bfb8-7df2e6593d78	0cd20caf-c4d0-4126-bfb8-7df2e6593d78	\N	\N	Unknown Contact	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/86337fab-ff99-4350-98e8-dd376641212f_1750141932368_Call recording Vikas Alagarsamy_250617_063053.m4a	Processing...	0.00	en	2025-06-17 12:02:12.369+05:30	2025-06-17 12:02:12.374+05:30	\N	transcribing	Uploaded from Android device - Employee: EMP-25-0001 - Phone: null	outgoing	processing
17394ffc-3190-40d2-8f7c-871d3347cf24	mobile_EMP001_9940379204	\N	\N	Mobile Call - 9940379204	EMP001	9940379204	120	\N	Updated transcript via PostgreSQL webhook	0.90	en	2025-06-16 11:53:53.485+05:30	2025-06-19 10:10:36.617+05:30	\N	processing	Direction: outgoing	outgoing	answered
5386f880-583c-4c24-bc8d-ead70ffc77fb	dc242ae9-c1a4-429f-a754-9ce133f665dd	\N	\N	John Smith	Sarah Johnson	+1234567890	120	\N	Hello, I am interested in wedding photography packages for my upcoming wedding in December.	1.00	en	2025-06-19 10:12:00.324+05:30	2025-06-19 10:12:00.324+05:30	\N	processing	\N	outgoing	processing
f236df45-1b63-4b09-85d2-7e9536689dd9	a388ce03-aba5-4a45-9faa-b196e81e1ad4	\N	\N	Mike Johnson	Emma Davis	+1987654321	180	/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/a388ce03-aba5-4a45-9faa-b196e81e1ad4_1750308174739_test_audio.txt	[Audio file uploaded: test_audio.txt]\nClient: Mike Johnson\nAgent: Emma Davis\nPhone: +1987654321\nDuration: 180 seconds\n\n[To enable automatic transcription, Whisper processing will be implemented next]	1.00	en	2025-06-19 10:12:54.748+05:30	2025-06-19 10:12:54.748+05:30	\N	processing	\N	outgoing	processing
abf64eed-5b62-4278-a9c9-135c9c36afde	abf64eed-5b62-4278-a9c9-135c9c36afde	\N	\N	Test Client	Photography AI Assistant	+91-UNKNOWN	0	http://localhost:3000/api/call-recordings/file/975aca2b-f70f-40a9-bcfc-4066a36c9f97_1750317217971_test_audio.txt	Processing failed: Translation failed: Command failed: source whisper-env/bin/activate && python "/Users/vikasalagarsamy/OOAK-FUTURE/scripts/faster-whisper-translate.py" "/Users/vikasalagarsamy/OOAK-FUTURE/uploads/call-recordings/975aca2b-f70f-40a9-bcfc-4066a36c9f97_1750317217971_test_audio.txt" "large-v3"\n	0.00	en	2025-06-19 12:43:37.982+05:30	2025-06-19 12:43:43.792+05:30	\N	error	Migration test call	outgoing	processing
\.


--
-- Data for Name: call_triggers; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.call_triggers (id, employee_id, phone_number, client_name, task_id, triggered_at, executed_at, status, response_data, created_at, updated_at) FROM stdin;
1	EMP-25-0001	+919677362524	Test Client	123	2025-06-16 16:47:28.115+05:30	\N	processing	\N	2025-06-16 16:47:28.116+05:30	2025-06-16 17:16:56.882+05:30
2	EMP-25-0001	+919677362524	Test Client	123	2025-06-16 16:47:42.703+05:30	\N	processing	\N	2025-06-16 16:47:42.704+05:30	2025-06-16 17:16:56.882+05:30
3	EMP-25-0001	+919677362524	Test Client	123	2025-06-16 16:49:36.923+05:30	\N	processing	\N	2025-06-16 16:49:36.93+05:30	2025-06-16 17:16:56.882+05:30
4	EMP-25-0001	+919677362524	Test Client	123	2025-06-16 16:51:01.42+05:30	\N	processing	\N	2025-06-16 16:51:01.421+05:30	2025-06-16 17:16:56.882+05:30
5	EMP-25-0001	+919677362524	Harish	147	2025-06-16 16:55:59.561+05:30	\N	processing	\N	2025-06-16 16:55:59.561+05:30	2025-06-16 17:16:56.882+05:30
6	EMP-25-0001	+919677362524	Harish	147	2025-06-16 16:56:20.907+05:30	\N	processing	\N	2025-06-16 16:56:20.907+05:30	2025-06-16 17:18:23.691+05:30
7	EMP-25-0001	+919677362524	Harish	147	2025-06-16 16:56:37.79+05:30	\N	processing	\N	2025-06-16 16:56:37.79+05:30	2025-06-16 17:18:23.691+05:30
8	EMP-25-0001	+919677362524	Harish	147	2025-06-16 16:56:47.458+05:30	\N	processing	\N	2025-06-16 16:56:47.458+05:30	2025-06-16 17:18:23.691+05:30
9	EMP-25-0001	+919677362524	Fresh Test Client	456	2025-06-16 17:04:45.022+05:30	\N	processing	\N	2025-06-16 17:04:45.023+05:30	2025-06-16 17:18:23.691+05:30
10	EMP-25-0001	+919677362524	Fresh Test Client	456	2025-06-16 17:05:48.656+05:30	\N	processing	\N	2025-06-16 17:05:48.657+05:30	2025-06-16 17:18:23.691+05:30
11	EMP-25-0001	+919677362524	Harish	147	2025-06-16 17:08:18.87+05:30	\N	processing	\N	2025-06-16 17:08:18.87+05:30	2025-06-16 19:03:36.043+05:30
12	EMP-25-0001	+919677362524	Harish	147	2025-06-16 17:10:09.056+05:30	\N	processing	\N	2025-06-16 17:10:09.058+05:30	2025-06-16 19:03:36.043+05:30
13	EMP-25-0001	+919677362524	Harish	147	2025-06-16 17:10:22.442+05:30	\N	processing	\N	2025-06-16 17:10:22.443+05:30	2025-06-16 19:03:36.043+05:30
14	EMP-25-0001	+919677362524	Harish	147	2025-06-16 17:22:18.096+05:30	\N	processing	\N	2025-06-16 17:22:18.096+05:30	2025-06-16 19:03:36.043+05:30
15	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-16 19:06:27.218+05:30	\N	completed	\N	2025-06-16 19:06:27.219+05:30	2025-06-16 19:06:27.329+05:30
16	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-16 19:06:45.774+05:30	\N	completed	\N	2025-06-16 19:06:45.774+05:30	2025-06-16 19:06:45.868+05:30
17	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-16 19:08:08.647+05:30	\N	completed	\N	2025-06-16 19:08:08.645+05:30	2025-06-16 19:08:08.756+05:30
18	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-16 19:21:55.969+05:30	\N	completed	\N	2025-06-16 19:21:55.97+05:30	2025-06-16 19:21:56.06+05:30
19	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-16 19:30:29.034+05:30	\N	completed	\N	2025-06-16 19:30:29.029+05:30	2025-06-16 19:30:29.126+05:30
20	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-16 19:31:05.927+05:30	\N	completed	\N	2025-06-16 19:31:05.927+05:30	2025-06-16 19:31:06.024+05:30
21	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-16 19:46:08.847+05:30	\N	completed	\N	2025-06-16 19:46:08.848+05:30	2025-06-16 19:46:08.961+05:30
22	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-17 06:30:47.376+05:30	\N	completed	\N	2025-06-17 06:30:47.376+05:30	2025-06-17 06:30:47.504+05:30
23	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-17 09:02:10.489+05:30	\N	completed	\N	2025-06-17 09:02:10.49+05:30	2025-06-17 09:02:10.666+05:30
24	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-17 09:22:37.332+05:30	\N	completed	\N	2025-06-17 09:22:37.337+05:30	2025-06-17 09:22:37.49+05:30
25	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-17 09:42:14.434+05:30	\N	completed	\N	2025-06-17 09:42:14.435+05:30	2025-06-17 09:42:14.573+05:30
26	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-17 09:52:11.744+05:30	2025-06-17 09:52:11.968+05:30	executed	\N	2025-06-17 09:52:11.744+05:30	2025-06-17 09:52:11.969+05:30
27	EMP-25-0001	+919677362524	Jothi Alagarsamy	78	2025-06-17 11:37:03.479+05:30	\N	completed	\N	2025-06-17 11:37:03.479+05:30	2025-06-17 11:37:03.613+05:30
28	EMP-25-0001	+1234567890	Test Client	\N	2025-06-19 10:15:47.335+05:30	\N	pending	\N	2025-06-19 10:15:47.335+05:30	2025-06-19 10:15:47.378+05:30
\.


--
-- Data for Name: chat_logs; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.chat_logs (id, phone, name, message, reply, channel, "timestamp") FROM stdin;
\.


--
-- Data for Name: client_communication_timeline; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.client_communication_timeline (id, quotation_id, client_phone, communication_type, communication_direction, content, "timestamp", employee_id, reference_id, metadata, created_at) FROM stdin;
1	\N	919677362524	whatsapp	inbound	Thanks	2025-06-12 23:13:21	\N	1	{"media_type": null, "interakt_message_id": "b433ed57-f031-4189-9c67-a3ca00892428"}	2025-06-13 04:43:22.362
2	\N	919677362524	whatsapp	inbound	Do you have my quotation ?	2025-06-12 23:16:13	\N	2	{"media_type": null, "interakt_message_id": "635e5199-d9e2-48a3-b80a-7989b9a74b39"}	2025-06-13 04:46:14.409
3	\N	918888888888	whatsapp	inbound	Testing AI protection system	2025-01-29 04:30:00	\N	3	{"media_type": null, "interakt_message_id": "test_protection"}	2025-06-13 04:47:22.911
4	\N	919677362524	whatsapp	inbound	Hi OOAK! Testing the AI system	2025-01-29 04:30:00	\N	4	{"media_type": null, "interakt_message_id": "test_allowed"}	2025-06-13 04:47:30.024
5	\N	919884261872	whatsapp	inbound	Please find the chnages based on this versions.. \nAlso we have included missing points which are not completed from the old one as well.\n\nOld change\n7. Thozhan taking groom on stage while holding groom's hand.\n19/05 - in new video timing changed, need to add before 4:33\n09/06 - in new video, need to add before 4:34\n\nNew video changes\n1. Pls add the thamboolam bags table and urli with flower kolam clip after 3:54 (this was available in previous edited video but missing in this new version)\n\n2. Bride father blessing thaali plate clip is missing..pls add before 6:27...\n\n3. 26:00 to 26:18 should come after 25:42 \n    25:43 to 25:58 should come after above one.\n(Bride & groom getting blessing from grooms family  come 1st follwed by getting blessing from bride parents)\n\n4. Seetha kalyana song 23:16 to 28:50, please make it completely instrumental no lyrics, if not possible please let us know\n Bakyia lakshmi song 28:50 to 30:00, please make it completely instrumental no lyrics, if not possible please let us know	2025-06-12 23:23:46	\N	5	{"media_type": null, "interakt_message_id": "b251c6bc-1c0c-45cd-b0b6-3060832b29c5"}	2025-06-13 04:53:48.233
6	\N	919884261872	whatsapp	inbound	Instrumental music means no lyrics at all	2025-06-12 23:24:08	\N	6	{"media_type": null, "interakt_message_id": "fce7b9d0-30ea-42f1-a3c6-97c8908f8679"}	2025-06-13 04:54:08.909
7	\N	919677362524	whatsapp	inbound	Hi OOAK! I need photography for my wedding. Can you share pricing?	2025-06-13 04:55:15	\N	7	{"media_type": null, "interakt_message_id": "test_incoming_001"}	2025-06-13 04:55:15.834
8	\N	919677362524	whatsapp	outbound	Portfolio: https://www.ooak.photography | Instagram: @ooak.photography	2025-06-13 04:55:17.226	\N	8	{"media_type": null, "interakt_message_id": "outgoing_1749810317219"}	2025-06-13 04:55:17.23
9	\N	918888888888	whatsapp	inbound	Hello, I'm interested in wedding photography	2025-06-13 04:55:20	\N	9	{"media_type": null, "interakt_message_id": "test_live_001"}	2025-06-13 04:55:20.483
10	\N	919677362524	whatsapp	inbound	What’s is candid photography means ?	2025-06-12 23:30:23	\N	10	{"media_type": null, "interakt_message_id": "c3207646-3eca-43a7-a3ae-1aa129473d99"}	2025-06-13 05:00:24.44
11	\N	919677362524	whatsapp	outbound	Portfolio: https://www.ooak.photography | Instagram: @ooak.photography	2025-06-13 05:00:26.465	\N	11	{"media_type": null, "interakt_message_id": "outgoing_1749810626462"}	2025-06-13 05:00:26.466
12	\N	919677362524	whatsapp	inbound	Testing improved quotation mapping system	2025-01-29 06:30:00	\N	12	{"media_type": null, "interakt_message_id": "test_mapping_001"}	2025-06-13 05:02:08.075
13	\N	919677362524	whatsapp	outbound	Candid photography captures natural moments without posing. You got it?	2025-06-13 05:02:13.295	\N	13	{"media_type": null, "interakt_message_id": "outgoing_1749810733287"}	2025-06-13 05:02:13.295
14	1	919677362524	whatsapp	inbound	Testing quotation mapping with improved phone matching	2025-01-29 06:35:00	\N	14	{"media_type": null, "interakt_message_id": "test_mapping_002"}	2025-06-13 05:03:20.074
15	1	919677362524	whatsapp	outbound	Yes, I got it. Candid photography captures natural moments without posing. Your test noted.	2025-06-13 05:03:25.336	\N	15	{"media_type": null, "interakt_message_id": "outgoing_1749810805332"}	2025-06-13 05:03:25.337
16	\N	917904348108	whatsapp	inbound	Hello hi	2025-06-12 23:38:09	\N	16	{"media_type": null, "interakt_message_id": "aee8d63f-fc86-4bd7-98d6-4325af020c2b"}	2025-06-13 05:08:11.595
17	1	919677362524	whatsapp	inbound	Hi Vikas! Do you remember my wedding details? When is my event?	2025-01-29 07:30:00	\N	17	{"media_type": null, "interakt_message_id": "test_context_001"}	2025-06-13 05:11:16.125
18	1	919677362524	whatsapp	outbound	Yes, your wedding is on June 24th. Confirmed.	2025-06-13 05:11:22.716	\N	18	{"media_type": null, "interakt_message_id": "outgoing_1749811282707"}	2025-06-13 05:11:22.717
19	1	919677362524	whatsapp	inbound	What package did we discuss? And whats the total amount?	2025-01-29 07:35:00	\N	19	{"media_type": null, "interakt_message_id": "test_context_002"}	2025-06-13 05:11:50.587
20	1	919677362524	whatsapp	outbound	Yes. Essential ₹75k, Premium ₹1.25L, Luxury ₹2L. Which interests you?	2025-06-13 05:11:51.902	\N	20	{"media_type": null, "interakt_message_id": "outgoing_1749811311895"}	2025-06-13 05:11:51.904
21	1	919677362524	whatsapp	inbound	What is my total quotation amount for the elite package?	2025-01-29 07:40:00	\N	21	{"media_type": null, "interakt_message_id": "test_context_003"}	2025-06-13 05:12:54.047
22	1	919677362524	whatsapp	outbound	Yes. Essential ₹75k, Premium ₹1.25L, Luxury ₹2L. Which interests you?	2025-06-13 05:12:54.886	\N	22	{"media_type": null, "interakt_message_id": "outgoing_1749811374878"}	2025-06-13 05:12:54.887
23	1	919677362524	whatsapp	inbound	Hi! Can you show me your portfolio?	2025-01-29 07:45:00	\N	23	{"media_type": null, "interakt_message_id": "test_working_001"}	2025-06-13 05:13:29.549
24	1	919677362524	whatsapp	outbound	Portfolio: https://www.ooak.photography | Instagram: @ooak.photography	2025-06-13 05:13:32.246	\N	24	{"media_type": null, "interakt_message_id": "outgoing_1749811412239"}	2025-06-13 05:13:32.248
25	1	919677362524	whatsapp	inbound	What is my exact quotation amount and package details?	2025-01-29 08:30:00	\N	25	{"media_type": null, "interakt_message_id": "test_comprehensive_001"}	2025-06-13 05:17:05.545
26	1	919677362524	whatsapp	outbound	Your Elite package quotation #1 is ₹245,000. Status: approved.	2025-06-13 05:17:09.738	\N	26	{"media_type": null, "interakt_message_id": "outgoing_1749811629732"}	2025-06-13 05:17:09.739
27	1	919677362524	whatsapp	inbound	What did we discuss in our previous conversations about photography?	2025-01-29 08:35:00	\N	27	{"media_type": null, "interakt_message_id": "test_comprehensive_002"}	2025-06-13 05:17:38.744
28	1	919677362524	whatsapp	outbound	We discussed candid photography and your portfolio questions.	2025-06-13 05:17:42.15	\N	28	{"media_type": null, "interakt_message_id": "outgoing_1749811662144"}	2025-06-13 05:17:42.152
29	1	919677362524	whatsapp	inbound	Who is the bride and groom in my quotation and what is the workflow status?	2025-01-29 08:40:00	\N	29	{"media_type": null, "interakt_message_id": "test_comprehensive_003"}	2025-06-13 05:18:04.411
30	1	919677362524	whatsapp	outbound	Bride: Ramya | Workflow Status: pending_approval	2025-06-13 05:18:08.527	\N	30	{"media_type": null, "interakt_message_id": "outgoing_1749811688520"}	2025-06-13 05:18:08.528
31	1	9677362524	whatsapp	inbound	Tell me my quotation details	2025-01-13 05:20:00	\N	31	{"media_type": null, "interakt_message_id": "test_msg_123"}	2025-06-13 05:27:56.637
32	1	9677362524	whatsapp	inbound	What is my quotation number?	2025-01-13 05:25:00	\N	32	{"media_type": null, "interakt_message_id": "test_msg_124"}	2025-06-13 05:29:20.941
33	1	9677362524	whatsapp	outbound	Your quotation number is QT-2025-0001.	2025-06-13 05:29:23.567	\N	33	{"media_type": null, "interakt_message_id": null}	2025-06-13 05:29:23.57
34	1	9677362524	whatsapp	inbound	What are bride and groom names?	2025-01-13 05:26:00	\N	34	{"media_type": null, "interakt_message_id": "test_msg_125"}	2025-06-13 05:29:46.604
35	1	9677362524	whatsapp	outbound	Bride is Ramya and groom is Noble.	2025-06-13 05:29:48.372	\N	35	{"media_type": null, "interakt_message_id": null}	2025-06-13 05:29:48.372
36	1	9677362524	whatsapp	inbound	What is my quotation status?	2025-01-13 05:27:00	\N	36	{"media_type": null, "interakt_message_id": "test_msg_126"}	2025-06-13 05:30:16.522
37	1	9677362524	whatsapp	outbound	Your quotation QT-2025-0001 status is pending_approval.	2025-06-13 05:30:18.544	\N	37	{"media_type": null, "interakt_message_id": null}	2025-06-13 05:30:18.547
38	1	9677362524	whatsapp	inbound	Tell me about my package and amount	2025-01-13 05:28:00	\N	38	{"media_type": null, "interakt_message_id": "test_msg_127"}	2025-06-13 05:32:38.796
39	1	9677362524	whatsapp	outbound	Your Elite package quotation QT-2025-0001 is ₹245,000. Still pending approval.	2025-06-13 05:32:41.142	\N	39	{"media_type": null, "interakt_message_id": null}	2025-06-13 05:32:41.145
40	\N	917032180673	whatsapp	inbound	Hi Durga, not yet due to emergency couldn’t finish the selection \n\nWill notify once it is done	2025-06-16 02:34:05	\N	40	{"media_type": null, "interakt_message_id": "2ea28e57-94ed-4cff-9c62-39b9df031df2"}	2025-06-16 08:04:07.487
41	\N	917032180673	whatsapp	inbound	.	2025-06-16 02:34:15	\N	41	{"media_type": null, "interakt_message_id": "0792a55f-bc7a-4133-a7c1-0ddd1744cb08"}	2025-06-16 08:04:15.65
42	\N	917032180673	whatsapp	inbound	Can you please confirm on this and size of the frame	2025-06-16 02:34:29	\N	42	{"media_type": null, "interakt_message_id": "2a53dd6d-fd67-487f-a14b-e42f0a234410"}	2025-06-16 08:04:29.726
43	\N	917032180673	whatsapp	inbound	Traditional Video looks good,\n\nI need clarification regarding the photo frame did it got printed or can we change the picture\n\nAnd what size frame will be given	2025-06-16 02:40:38	\N	43	{"media_type": null, "interakt_message_id": "2e746354-ae4e-4f1a-81ef-4abd30bc66a6"}	2025-06-16 08:10:39.741
44	\N	917032180673	whatsapp	inbound	None	2025-06-16 02:55:36	\N	44	{"media_type": null, "interakt_message_id": "c61e4e80-135a-4954-93bd-c14da7ab968f"}	2025-06-16 08:25:40.657
45	\N	918008895327	whatsapp	inbound	Hi	2025-06-16 02:58:30	\N	45	{"media_type": null, "interakt_message_id": "9a10b1c8-7730-4969-ae6c-552345432d72"}	2025-06-16 08:28:33.976
46	\N	918008895327	whatsapp	inbound	This is Joseph freelance candid photographer	2025-06-16 02:58:35	\N	46	{"media_type": null, "interakt_message_id": "9ffc7440-f891-439c-93fc-d1fbe7cf1d3e"}	2025-06-16 08:28:36.36
47	\N	918008895327	whatsapp	inbound	Check out my portfolio	2025-06-16 02:59:00	\N	47	{"media_type": null, "interakt_message_id": "3a8cf34a-e504-49fb-90cc-e6f5345331e5"}	2025-06-16 08:29:01.508
48	\N	918008895327	whatsapp	inbound	If there is any Requirement pls let me know	2025-06-16 02:59:07	\N	48	{"media_type": null, "interakt_message_id": "f0352e0f-ceaa-4d70-823a-ff01cb28b3fe"}	2025-06-16 08:29:07.914
49	\N	917032180673	whatsapp	inbound	Thank you.\n\nNeed one confirmation regarding editing my sister in the above picture \n\nFor album and the frame \n\nI will share the pic. Please check with your team and let me know	2025-06-16 17:14:40	\N	49	{"media_type": null, "interakt_message_id": "8e44dae3-510d-4264-9b4c-8cfe3aca2235"}	2025-06-16 22:44:43.697
50	\N	917032180673	whatsapp	inbound	None	2025-06-16 17:15:03	\N	50	{"media_type": null, "interakt_message_id": "80e21117-1a44-44a1-9252-4e42f7ba7aca"}	2025-06-16 22:45:06.539
51	\N	918553925800	whatsapp	inbound	Please call Nikitha for this	2025-06-16 17:17:21	\N	51	{"media_type": null, "interakt_message_id": "5bc11e0e-8b4c-4aa1-b61d-022dcc9ac782"}	2025-06-16 22:47:22.113
52	\N	919626308646	whatsapp	inbound	3.48- 4.15	2025-06-16 17:22:05	\N	52	{"media_type": null, "interakt_message_id": "7a2e0669-e375-45a9-8a61-2892f4b4ede2"}	2025-06-16 22:52:06.804
53	\N	919626308646	whatsapp	inbound	Yes	2025-06-16 17:24:54	\N	53	{"media_type": null, "interakt_message_id": "daf242c9-987c-4939-a435-24b00fd4da18"}	2025-06-16 22:54:56.494
54	\N	919626308646	whatsapp	inbound	Add couple clips	2025-06-16 17:25:09	\N	54	{"media_type": null, "interakt_message_id": "04531c90-8d60-41f4-99d1-175385e7af1d"}	2025-06-16 22:55:09.3
55	\N	917358592603	whatsapp	inbound	Nachde ne saare - from Baar baar dekho \nOr kabira (encore ) - from Yeh Jawaani hai Deewani	2025-06-16 17:27:26	\N	55	{"media_type": null, "interakt_message_id": "8bce2956-8260-441c-8811-2b7206a276b4"}	2025-06-16 22:57:26.647
56	\N	917032180673	whatsapp	inbound	Noted, thank you	2025-06-16 17:33:05	\N	56	{"media_type": null, "interakt_message_id": "fcbbc1e6-1d3c-4aaa-aaa4-073fc7b7e3a3"}	2025-06-16 23:03:06.199
57	\N	918748065227	whatsapp	inbound	Ok	2025-06-16 18:09:21	\N	57	{"media_type": null, "interakt_message_id": "c58b0596-2738-4925-a8b1-37dd2e696690"}	2025-06-16 23:39:22.722
58	\N	917032180673	whatsapp	inbound	Okay	2025-06-16 18:15:47	\N	58	{"media_type": null, "interakt_message_id": "2d46f7a4-7495-414b-983b-5f8a20d66248"}	2025-06-16 23:45:49.21
59	\N	919652279284	whatsapp	inbound	Hello. \nWe are okay with traditional video	2025-06-16 18:23:19	\N	59	{"media_type": null, "interakt_message_id": "2d754ec6-9ab0-42d0-bb98-a80e7d88f2c0"}	2025-06-16 23:53:21.053
60	\N	919652279284	whatsapp	inbound	When can we expect hybrid video ?	2025-06-16 18:23:53	\N	60	{"media_type": null, "interakt_message_id": "24b12cdc-3922-4005-ba68-2fdb5df9d1c6"}	2025-06-16 23:53:54.943
61	\N	919652279284	whatsapp	inbound	Okay	2025-06-16 18:32:56	\N	61	{"media_type": null, "interakt_message_id": "ee2ef543-216f-4409-84b2-43d714f07ba1"}	2025-06-17 00:02:57.368
62	\N	919652279284	whatsapp	inbound	Yeah	2025-06-16 18:38:07	\N	62	{"media_type": null, "interakt_message_id": "5df603aa-13b1-46f5-b677-300ad6e7a580"}	2025-06-17 00:08:08.392
63	\N	919652279284	whatsapp	inbound	We got it	2025-06-16 18:38:12	\N	63	{"media_type": null, "interakt_message_id": "acfe72fd-b528-4a1b-9a0f-8b91fd2fa6b8"}	2025-06-17 00:08:12.308
64	\N	919229303189	whatsapp	inbound	I need job sir..	2025-06-16 19:01:59	\N	64	{"media_type": null, "interakt_message_id": "45e9a69a-f89e-44a8-bbf1-ed0a9cfa6ba6"}	2025-06-17 00:32:01.496
65	\N	917032180673	whatsapp	inbound	By this Friday will complete the selection	2025-06-16 19:06:42	\N	65	{"media_type": null, "interakt_message_id": "ffbb1713-69ce-4193-8b03-cd16e18fa4a7"}	2025-06-17 00:36:44.199
66	\N	919182912008	whatsapp	inbound	my parents are looking on that	2025-06-17 23:21:27	\N	66	{"media_type": null, "interakt_message_id": "84858ef1-6da1-4113-a4f1-39f54a7a78a0"}	2025-06-18 04:51:31.958
71	\N	919677362524	whatsapp	inbound	WhatsApp table verified successfully! Ready for real-time testing with PostgreSQL and existing business schema.	2025-06-19 01:23:28.826	\N	71	{"media_type": null, "interakt_message_id": "setup_test_1750316008838"}	2025-06-19 01:23:28.826
\.


--
-- Data for Name: client_insights; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.client_insights (id, client_name, client_email, client_phone, sentiment_score, engagement_level, conversion_probability, preferred_communication_method, optimal_follow_up_time, price_sensitivity, decision_timeline_days, insights, last_analyzed_at, created_at) FROM stdin;
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.clients (id, client_code, name, company_id, contact_person, email, phone, address, city, state, postal_code, country, category, status, notes, created_at, updated_at, country_code, is_whatsapp, whatsapp_country_code, whatsapp_number, has_separate_whatsapp) FROM stdin;
\.


--
-- Data for Name: communications; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.communications (id, channel_type, message_id, sender_type, sender_id, sender_name, recipient_type, recipient_id, recipient_name, content_type, content_text, content_metadata, business_context, ai_processed, ai_priority_score, sent_at, created_at, updated_at) FROM stdin;
1	whatsapp	setup_test_1750316008838	client	919677362524	Test Client	employee	business	Business	text	WhatsApp table verified successfully!	{"test_setup": true, "table_schema": "business_compatible"}	setup_test	f	0.50	2025-06-19 12:23:28.826+05:30	2025-06-19 12:23:28.826+05:30	2025-06-19 12:23:28.826+05:30
3	instagram	comment_test_789	client	user_test_commenter	test_commenter	employee	\N	Business Account	text	This is amazing! Do you work in Mumbai?	{"post_id": "post_123", "comment_type": "post_comment"}	social_engagement	f	0.60	2024-01-01 15:30:00+05:30	2025-06-19 12:40:46.199+05:30	2025-06-19 12:40:46.199+05:30
4	call	abf64eed-5b62-4278-a9c9-135c9c36afde	client	+91-UNKNOWN	Test Client	employee	Photography AI Assistant	Photography AI Assistant	audio	Call upload: test_audio.txt	{"task_id": "", "file_name": "test_audio.txt", "file_size": 19, "recording_url": "http://localhost:3000/api/call-recordings/file/975aca2b-f70f-40a9-bcfc-4066a36c9f97_1750317217971_test_audio.txt"}	call_upload	f	0.80	2025-06-19 12:43:37.985+05:30	2025-06-19 12:43:37.985+05:30	2025-06-19 12:43:37.985+05:30
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.companies (id, name, registration_number, tax_id, address, phone, email, website, founded_date, created_at, updated_at, company_code) FROM stdin;
3	WEDDINGS BY OOAK	\N	\N	Sai Baba Colony,\nCoimbatore	09500999861	vikas@weddingsbyooak.com	\N	2022-04-07	2025-06-13 15:55:48.289+05:30	2025-06-13 15:55:48.289+05:30	WBOOAK
4	YOUR PERFECT STORY	\N	\N	15/34, Thirumangalam Road, Navalar Nagar, Anna Nagar West,	\N	vikas@ooak.photography	\N	\N	2025-06-13 15:56:06.097+05:30	2025-06-13 15:56:06.097+05:30	YPS
1	OOAK AI	\N	\N	123 Business St	09677362524	hello@ooak.ai	\N	\N	2025-06-17 12:51:24.411+05:30	2025-06-17 12:51:24.411+05:30	OOAKAI
2	ONE OF A KIND	TN-REG-123456	33AACCW8491J1ZV	Plot No: 17 & 17A, Old Door No: 446/2, New Door No.339 1st Floor, Poonamallee High Rd, near by D.G Vaishnav College, Arumbakkam,	9677362524	hello@ooak.photography	https://www.ooak.photography	2021-10-28	2025-06-13 05:31:47.186+05:30	2025-06-23 12:28:20.002191+05:30	OOAK
6	WHITE REFLECTIONS PRIVATE LIMITED	\N	\N	15/34, Thirumangalam Road, Navalar Nagar, Anna Nagar West,	09677362524	vikas@ooak.photography	\N	\N	2025-06-23 18:57:55.985737+05:30	2025-06-23 18:57:55.985737+05:30	WR
\.


--
-- Data for Name: company_partners; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.company_partners (company_id, partner_id, contract_details, contract_start_date, contract_end_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: conversation_sessions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.conversation_sessions (id, quotation_id, client_phone, session_start, session_end, message_count, overall_sentiment, business_outcome, ai_summary, created_at, updated_at) FROM stdin;
1	1	+919677362524	2025-06-11 04:19:01.896	2025-06-12 04:19:01.896	0	positive	\N	Client showed interest in the photography package and asked about additional services.	2025-06-13 04:19:01.896	2025-06-13 04:19:01.896
2	\N	919677362524	2025-06-12 23:13:21	\N	1	\N	\N	\N	2025-06-13 04:43:22.362	2025-06-13 04:43:22.362
3	\N	919677362524	2025-06-12 23:16:13	\N	1	\N	\N	\N	2025-06-13 04:46:14.409	2025-06-13 04:46:14.409
4	\N	918888888888	2025-01-29 04:30:00	\N	1	\N	\N	\N	2025-06-13 04:47:22.911	2025-06-13 04:47:22.911
5	\N	919677362524	2025-01-29 04:30:00	\N	1	\N	\N	\N	2025-06-13 04:47:30.024	2025-06-13 04:47:30.024
6	\N	919884261872	2025-06-12 23:23:46	\N	1	\N	\N	\N	2025-06-13 04:53:48.233	2025-06-13 04:53:48.233
7	\N	919884261872	2025-06-12 23:24:08	\N	1	\N	\N	\N	2025-06-13 04:54:08.909	2025-06-13 04:54:08.909
8	\N	919677362524	2025-06-13 04:55:15	\N	1	\N	\N	\N	2025-06-13 04:55:15.834	2025-06-13 04:55:15.834
9	\N	919677362524	2025-06-13 04:55:17.226	\N	1	\N	\N	\N	2025-06-13 04:55:17.23	2025-06-13 04:55:17.23
10	\N	918888888888	2025-06-13 04:55:20	\N	1	\N	\N	\N	2025-06-13 04:55:20.483	2025-06-13 04:55:20.483
11	\N	919677362524	2025-06-12 23:30:23	\N	1	\N	\N	\N	2025-06-13 05:00:24.44	2025-06-13 05:00:24.44
12	\N	919677362524	2025-06-13 05:00:26.465	\N	1	\N	\N	\N	2025-06-13 05:00:26.466	2025-06-13 05:00:26.466
13	\N	919677362524	2025-01-29 06:30:00	\N	1	\N	\N	\N	2025-06-13 05:02:08.075	2025-06-13 05:02:08.075
14	\N	919677362524	2025-06-13 05:02:13.295	\N	1	\N	\N	\N	2025-06-13 05:02:13.295	2025-06-13 05:02:13.295
16	1	919677362524	2025-01-29 06:35:00	2025-01-29 06:35:00	1	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:03:20.11	2025-06-13 05:03:20.11
15	1	919677362524	2025-01-29 06:35:00	2025-06-13 05:03:25.336	2	\N	\N	\N	2025-06-13 05:03:20.074	2025-06-13 05:03:25.337
17	1	919677362524	2025-01-29 06:35:00	2025-06-13 05:03:25.336	2	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:03:25.363	2025-06-13 05:03:25.363
18	\N	917904348108	2025-06-12 23:38:09	\N	1	\N	\N	\N	2025-06-13 05:08:11.595	2025-06-13 05:08:11.595
20	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:03:25.336	12	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:11:16.154	2025-06-13 05:11:16.154
19	1	919677362524	2025-01-29 07:30:00	2025-06-13 05:11:22.716	2	\N	\N	\N	2025-06-13 05:11:16.125	2025-06-13 05:11:22.717
21	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:11:22.716	13	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:11:22.736	2025-06-13 05:11:22.736
23	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:11:22.716	14	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:11:50.604	2025-06-13 05:11:50.604
22	1	919677362524	2025-01-29 07:35:00	2025-06-13 05:11:51.902	2	\N	\N	\N	2025-06-13 05:11:50.587	2025-06-13 05:11:51.904
24	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:11:51.902	15	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:11:51.924	2025-06-13 05:11:51.924
26	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:11:51.902	16	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:12:54.068	2025-06-13 05:12:54.068
25	1	919677362524	2025-01-29 07:40:00	2025-06-13 05:12:54.886	2	\N	\N	\N	2025-06-13 05:12:54.047	2025-06-13 05:12:54.887
27	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:12:54.886	17	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:12:54.906	2025-06-13 05:12:54.906
29	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:12:54.886	18	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:13:29.571	2025-06-13 05:13:29.571
28	1	919677362524	2025-01-29 07:45:00	2025-06-13 05:13:32.246	2	\N	\N	\N	2025-06-13 05:13:29.549	2025-06-13 05:13:32.248
30	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:13:32.246	19	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:13:32.264	2025-06-13 05:13:32.264
32	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:13:32.246	20	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:17:05.587	2025-06-13 05:17:05.587
31	1	919677362524	2025-01-29 08:30:00	2025-06-13 05:17:09.738	2	\N	\N	\N	2025-06-13 05:17:05.545	2025-06-13 05:17:09.739
33	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:17:09.738	21	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:17:09.759	2025-06-13 05:17:09.759
35	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:17:09.738	22	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:17:38.767	2025-06-13 05:17:38.767
34	1	919677362524	2025-01-29 08:35:00	2025-06-13 05:17:42.15	2	\N	\N	\N	2025-06-13 05:17:38.744	2025-06-13 05:17:42.152
36	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:17:42.15	23	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:17:42.17	2025-06-13 05:17:42.17
38	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:17:42.15	24	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:18:04.429	2025-06-13 05:18:04.429
37	1	919677362524	2025-01-29 08:40:00	2025-06-13 05:18:08.527	2	\N	\N	\N	2025-06-13 05:18:04.411	2025-06-13 05:18:08.528
39	1	919677362524	2025-01-29 04:30:00	2025-06-13 05:18:08.527	25	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:18:08.545	2025-06-13 05:18:08.545
41	1	9677362524	2025-01-13 05:20:00	2025-06-13 05:18:08.527	26	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:27:57.678	2025-06-13 05:27:57.678
40	1	9677362524	2025-01-13 05:20:00	2025-01-13 05:25:00	2	\N	\N	\N	2025-06-13 05:27:56.637	2025-06-13 05:29:20.941
43	1	9677362524	2025-01-13 05:20:00	2025-06-13 05:29:23.567	28	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:29:25.597	2025-06-13 05:29:25.597
42	1	9677362524	2025-06-13 05:29:23.567	2025-01-13 05:26:00	2	\N	\N	\N	2025-06-13 05:29:23.57	2025-06-13 05:29:46.604
45	1	9677362524	2025-01-13 05:20:00	2025-06-13 05:29:48.372	30	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:29:50.396	2025-06-13 05:29:50.396
44	1	9677362524	2025-06-13 05:29:48.372	2025-01-13 05:27:00	2	\N	\N	\N	2025-06-13 05:29:48.372	2025-06-13 05:30:16.522
47	1	9677362524	2025-01-13 05:20:00	2025-06-13 05:30:18.544	32	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:30:20.574	2025-06-13 05:30:20.574
46	1	9677362524	2025-06-13 05:30:18.544	2025-01-13 05:28:00	2	\N	\N	\N	2025-06-13 05:30:18.547	2025-06-13 05:32:38.796
48	1	9677362524	2025-06-13 05:32:41.142	\N	1	\N	\N	\N	2025-06-13 05:32:41.145	2025-06-13 05:32:41.145
49	1	9677362524	2025-01-13 05:20:00	2025-06-13 05:32:41.142	34	neutral	\N	Unable to analyze conversation - LLM connection failed	2025-06-13 05:32:43.171	2025-06-13 05:32:43.171
50	\N	917032180673	2025-06-16 02:34:05	\N	1	\N	\N	\N	2025-06-16 08:04:07.487	2025-06-16 08:04:07.487
51	\N	917032180673	2025-06-16 02:34:15	\N	1	\N	\N	\N	2025-06-16 08:04:15.65	2025-06-16 08:04:15.65
52	\N	917032180673	2025-06-16 02:34:29	\N	1	\N	\N	\N	2025-06-16 08:04:29.726	2025-06-16 08:04:29.726
53	\N	917032180673	2025-06-16 02:40:38	\N	1	\N	\N	\N	2025-06-16 08:10:39.741	2025-06-16 08:10:39.741
54	\N	917032180673	2025-06-16 02:55:36	\N	1	\N	\N	\N	2025-06-16 08:25:40.657	2025-06-16 08:25:40.657
55	\N	918008895327	2025-06-16 02:58:30	\N	1	\N	\N	\N	2025-06-16 08:28:33.976	2025-06-16 08:28:33.976
56	\N	918008895327	2025-06-16 02:58:35	\N	1	\N	\N	\N	2025-06-16 08:28:36.36	2025-06-16 08:28:36.36
57	\N	918008895327	2025-06-16 02:59:00	\N	1	\N	\N	\N	2025-06-16 08:29:01.508	2025-06-16 08:29:01.508
58	\N	918008895327	2025-06-16 02:59:07	\N	1	\N	\N	\N	2025-06-16 08:29:07.914	2025-06-16 08:29:07.914
59	\N	917032180673	2025-06-16 17:14:40	\N	1	\N	\N	\N	2025-06-16 22:44:43.697	2025-06-16 22:44:43.697
60	\N	917032180673	2025-06-16 17:15:03	\N	1	\N	\N	\N	2025-06-16 22:45:06.539	2025-06-16 22:45:06.539
61	\N	918553925800	2025-06-16 17:17:21	\N	1	\N	\N	\N	2025-06-16 22:47:22.113	2025-06-16 22:47:22.113
62	\N	919626308646	2025-06-16 17:22:05	\N	1	\N	\N	\N	2025-06-16 22:52:06.804	2025-06-16 22:52:06.804
63	\N	919626308646	2025-06-16 17:24:54	\N	1	\N	\N	\N	2025-06-16 22:54:56.494	2025-06-16 22:54:56.494
64	\N	919626308646	2025-06-16 17:25:09	\N	1	\N	\N	\N	2025-06-16 22:55:09.3	2025-06-16 22:55:09.3
65	\N	917358592603	2025-06-16 17:27:26	\N	1	\N	\N	\N	2025-06-16 22:57:26.647	2025-06-16 22:57:26.647
66	\N	917032180673	2025-06-16 17:33:05	\N	1	\N	\N	\N	2025-06-16 23:03:06.199	2025-06-16 23:03:06.199
67	\N	918748065227	2025-06-16 18:09:21	\N	1	\N	\N	\N	2025-06-16 23:39:22.722	2025-06-16 23:39:22.722
68	\N	917032180673	2025-06-16 18:15:47	\N	1	\N	\N	\N	2025-06-16 23:45:49.21	2025-06-16 23:45:49.21
69	\N	919652279284	2025-06-16 18:23:19	\N	1	\N	\N	\N	2025-06-16 23:53:21.053	2025-06-16 23:53:21.053
70	\N	919652279284	2025-06-16 18:23:53	\N	1	\N	\N	\N	2025-06-16 23:53:54.943	2025-06-16 23:53:54.943
71	\N	919652279284	2025-06-16 18:32:56	\N	1	\N	\N	\N	2025-06-17 00:02:57.368	2025-06-17 00:02:57.368
72	\N	919652279284	2025-06-16 18:38:07	\N	1	\N	\N	\N	2025-06-17 00:08:08.392	2025-06-17 00:08:08.392
73	\N	919652279284	2025-06-16 18:38:12	\N	1	\N	\N	\N	2025-06-17 00:08:12.308	2025-06-17 00:08:12.308
74	\N	919229303189	2025-06-16 19:01:59	\N	1	\N	\N	\N	2025-06-17 00:32:01.496	2025-06-17 00:32:01.496
75	\N	917032180673	2025-06-16 19:06:42	\N	1	\N	\N	\N	2025-06-17 00:36:44.199	2025-06-17 00:36:44.199
76	\N	919182912008	2025-06-17 23:21:27	\N	1	\N	\N	\N	2025-06-18 04:51:31.958	2025-06-18 04:51:31.958
81	\N	919677362524	2025-06-19 01:23:28.826	\N	1	\N	\N	\N	2025-06-19 01:23:28.826	2025-06-19 01:23:28.826
\.


--
-- Data for Name: deliverable_master; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.deliverable_master (id, category, type, deliverable_name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: deliverables; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.deliverables (id, deliverable_cat, deliverable_type, deliverable_id, deliverable_name, process_name, has_customer, has_employee, has_qc, has_vendor, link, sort_order, timing_type, tat, tat_value, buffer, skippable, employee, has_download_option, has_task_process, has_upload_folder_path, process_starts_from, status, on_start_template, on_complete_template, on_correction_template, input_names, created_date, created_by, stream, stage, package_included, basic_price, elite_price, premium_price) FROM stdin;
1	Main	Photo	\N	TRADITIONAL ALBUM 250 X 40	TRADITIONAL ALBUM 250 X 40	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-13 09:26:19.404+05:30	1	\N	\N	{"basic": true, "elite": true, "premium": true}	15000	25000	20000
2	Main	Photo	\N	TRADITIONAL ALBUM 350 X 50	TRADITIONAL ALBUM 350 X 50	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-13 09:27:01.72+05:30	1	\N	\N	{"basic": true, "elite": true, "premium": true}	25000	35000	30000
3	Main	Video	\N	CANDID VIDEO	CANDID VIDEO	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-13 09:27:27.566+05:30	1	\N	\N	{"basic": true, "elite": true, "premium": true}	10000	20000	15000
4	Main	Video	\N	TRADITIONAL VIDEO	TRADITIONAL VIDEO	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-13 09:27:54.439+05:30	1	\N	\N	{"basic": true, "elite": true, "premium": true}	5000	15000	10000
5	Optional	Photo	\N	COMPLIMENTARY MAGAZINE	COMPLIMENTARY MAGAZINE	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-13 09:28:24.149+05:30	1	\N	\N	{"basic": true, "elite": true, "premium": true}	10000	15000	12500
6	Optional	Photo	\N	COMPLIMENTARY FRAME	COMPLIMENTARY FRAME	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-13 09:28:51.234+05:30	1	\N	\N	{"basic": true, "elite": true, "premium": true}	10000	15000	12500
7	Optional	Video	\N	CANDID TEASER HIGHTLIGHTS	CANDID TEASER HIGHTLIGHTS	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-13 09:29:28.069+05:30	1	\N	\N	{"basic": true, "elite": true, "premium": true}	5000	15000	10000
8	Main	Photo	\N	CANDID ALBUM	CANDID ALBUM	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-17 11:26:52.701+05:30	6	\N	\N	{"basic": true, "elite": true, "premium": true}	20000	30000	25000
9	Main	Photo	\N	TRADITIONAL ALBUM 200 X 35	TRADITIONAL ALBUM 200 X 35	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-17 11:28:41.081+05:30	6	\N	\N	{"basic": true, "elite": true, "premium": true}	10000	20000	15000
10	Optional	Photo	\N	COLOR CORRECTED PICTURES	COLOR CORRECTED PICTURES	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-17 11:29:49.771+05:30	6	\N	\N	{"basic": true, "elite": true, "premium": true}	0	0	0
11	Optional	Photo	\N	PRE/POST WEDDING COLOR CORRECTED PICTURES	PRE/POST WEDDING COLOR CORRECTED PICTURES	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-17 11:32:28.058+05:30	6	\N	\N	{"basic": true, "elite": true, "premium": true}	0	0	0
12	Optional	Photo	\N	EDITED PICTURES	EDITED PICTURES	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-17 11:32:45.15+05:30	6	\N	\N	{"basic": true, "elite": true, "premium": true}	0	0	0
13	Optional	Photo	\N	PRE/POST WEDDING EDITED PICTURES	PRE/POST WEDDING EDITED PICTURES	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-17 11:33:04.321+05:30	6	\N	\N	{"basic": true, "elite": true, "premium": true}	0	0	0
14	Optional	Video	\N	INSTAGRAM REELS	INSTAGRAM REELS	f	f	f	f	\N	0	days	\N	\N	\N	f	\N	f	t	f	0	1	\N	\N	\N	\N	2025-06-17 11:37:16.673+05:30	6	\N	\N	{"basic": true, "elite": true, "premium": true}	0	0	0
\.


--
-- Data for Name: department_instructions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.department_instructions (id, quotation_id, payment_id, instructions, status, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.departments (id, name, description, manager_id, parent_department_id, created_at, updated_at) FROM stdin;
2	MANAGEMENT	MANAGEMENT	\N	\N	2025-06-13 05:49:17.888+05:30	2025-06-13 05:49:17.888+05:30
3	OFFICE ADMINISTRATION	OFFICE ADMINISTRATION	\N	\N	2025-06-13 05:53:20.962+05:30	2025-06-13 05:53:20.962+05:30
1	SALES	SALES	\N	\N	2025-06-13 05:32:52.623+05:30	2025-06-13 05:54:33.235+05:30
4	ACCOUNTS	ACCOUNTS	\N	\N	2025-06-13 10:59:35.408+05:30	2025-06-13 10:59:35.408+05:30
5	EVENT COORDINATION	EVENT COORDINATION	\N	\N	2025-06-13 10:59:42.348+05:30	2025-06-13 10:59:42.348+05:30
6	POST PRODUCTION	POST PRODUCTION	\N	\N	2025-06-13 10:59:50.354+05:30	2025-06-13 10:59:50.354+05:30
7	PHOTOGRAPHY	PHOTOGRAPHY	\N	\N	2025-06-13 10:59:59.687+05:30	2025-06-13 10:59:59.687+05:30
8	CINEMATOGRAPHY	CINEMATOGRAPHY	\N	\N	2025-06-13 11:00:43.038+05:30	2025-06-13 11:00:43.038+05:30
9	VIDEOGRAPHY	VIDEOGRAPHY	\N	\N	2025-06-13 11:00:49.539+05:30	2025-06-13 11:00:49.539+05:30
10	HUMAN RESOURCE	HUMAN RESOURCE	\N	\N	2025-06-13 11:00:58.614+05:30	2025-06-13 11:00:58.614+05:30
11	DATA MANAGEMENT	DATA MANAGEMENT	\N	\N	2025-06-13 11:01:13.702+05:30	2025-06-13 11:01:13.702+05:30
12	SOCIAL MEDIA	SOCIAL MEDIA	\N	\N	2025-06-13 11:01:34.851+05:30	2025-06-13 11:01:34.851+05:30
13	RETOUCH	RETOUCH	\N	\N	2025-06-13 11:18:33.577+05:30	2025-06-13 11:18:33.577+05:30
14	BUSINESS DEVELOPMENT	BUSINESS DEVELOPMENT	\N	\N	2025-06-13 11:18:51.467+05:30	2025-06-13 11:18:51.467+05:30
15	SUPPORT SERVICE	SUPPORT SERVICE	\N	\N	2025-06-13 11:19:08.597+05:30	2025-06-13 11:19:08.597+05:30
16	VIDEO EDITING	VIDEO EDITING	\N	\N	2025-06-13 11:19:30.223+05:30	2025-06-13 11:19:30.223+05:30
17	VENDOR	VENDOR	\N	\N	2025-06-13 11:19:46.911+05:30	2025-06-13 11:19:46.911+05:30
18	CANDID PHOTOGRAPHY	CANDID PHOTOGRAPHY	\N	\N	2025-06-13 11:20:14.882+05:30	2025-06-13 11:20:14.882+05:30
19	COLOUR CORRECTION	COLOUR CORRECTION	\N	\N	2025-06-13 11:20:37.475+05:30	2025-06-13 11:20:37.475+05:30
21	QUALITY CHECK	QUALITY CHECK	\N	\N	2025-06-13 13:26:20.636+05:30	2025-06-13 13:26:20.636+05:30
20	CREATIVE DESIGNING	DESIGN	\N	\N	2025-06-13 11:20:53.409+05:30	2025-06-23 18:15:06.244192+05:30
22	SOFTWARE DEVELOPER	SOFTWARE DEVELOPER	\N	\N	2025-06-23 18:15:28.239955+05:30	2025-06-23 18:15:28.239955+05:30
\.


--
-- Data for Name: designation_menu_permissions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.designation_menu_permissions (id, designation_id, menu_item_id, can_view, created_at, updated_at, created_by, updated_by) FROM stdin;
988	3	1	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
989	3	3	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
990	3	2	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
992	3	5	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
993	3	6	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
995	3	7	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
997	3	8	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1335	4	3	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
999	3	9	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1334	4	1	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1001	3	10	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1337	4	2	f	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1003	3	11	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1005	3	12	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1007	3	13	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1339	4	5	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1009	3	14	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1011	3	15	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1341	4	6	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1013	3	18	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1015	3	19	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1017	3	20	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1019	3	21	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
991	3	4	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1021	3	22	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1022	3	23	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1023	3	24	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1024	3	25	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1025	3	26	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1026	3	27	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1027	3	28	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1028	3	29	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1029	3	30	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1030	3	31	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1031	3	32	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1032	3	33	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1033	3	34	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1034	3	35	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1035	3	36	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1036	3	37	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1037	3	38	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1038	3	39	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1039	3	40	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1040	3	41	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1041	3	42	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1042	3	43	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1043	3	44	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1044	3	45	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1045	3	46	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1046	3	47	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1047	3	48	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1048	3	49	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1049	3	50	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1050	3	51	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1051	3	52	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1052	3	53	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1053	3	54	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1054	3	55	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1055	3	56	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1056	3	57	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1057	3	58	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1058	3	59	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1059	3	60	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1060	3	61	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1061	3	62	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1062	3	63	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1063	3	68	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1064	3	69	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1343	4	7	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1065	3	70	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1066	3	71	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1067	3	72	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1345	4	8	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1069	3	77	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1347	4	9	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1071	3	78	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1349	4	10	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1068	3	73	t	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1073	3	79	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1074	3	80	f	2025-06-23 10:51:10.944687+05:30	2025-06-23 10:51:10.944687+05:30	EMP-25-0001	EMP-25-0001
1351	4	11	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1353	4	12	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1355	4	13	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1357	4	14	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1359	4	15	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1361	4	18	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1363	4	19	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1365	4	20	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1367	4	21	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1338	4	4	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1370	4	23	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1372	4	24	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1374	4	25	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1376	4	26	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1378	4	27	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1369	4	22	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1380	4	28	f	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1381	4	29	f	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1382	4	30	f	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1383	4	31	f	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1385	4	33	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1387	4	34	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1389	4	35	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1391	4	36	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1384	4	32	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1394	4	38	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1396	4	39	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1398	4	40	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1400	4	41	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1402	4	42	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
215	34	1	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
216	34	3	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
217	34	2	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
218	34	4	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
219	34	5	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
220	34	6	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
221	34	7	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
222	34	8	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
223	34	9	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
224	34	10	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
225	34	11	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
226	34	12	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
227	34	13	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
228	34	14	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
229	34	15	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
230	34	18	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
231	34	19	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
232	34	20	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
233	34	21	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
234	34	22	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
235	34	23	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
236	34	24	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
237	34	25	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
238	34	26	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
239	34	27	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
240	34	28	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
241	34	29	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
242	34	30	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
243	34	31	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
244	34	32	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
245	34	33	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
246	34	34	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
247	34	35	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
248	34	36	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
249	34	37	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
250	34	38	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
251	34	39	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
252	34	40	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
253	34	41	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
254	34	42	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
255	34	43	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
256	34	44	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
257	34	45	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
258	34	46	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
259	34	47	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
260	34	48	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
261	34	49	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
262	34	50	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
263	34	51	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
264	34	52	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
265	34	53	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
266	34	54	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
267	34	55	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
268	34	56	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
269	34	57	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
270	34	58	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
272	34	60	t	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
274	34	61	t	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
276	34	62	t	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
278	34	63	t	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
271	34	59	t	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
281	34	69	t	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
1404	4	43	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
283	34	70	t	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
285	34	71	t	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
1406	4	44	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
287	34	72	t	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
280	34	68	t	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
289	34	73	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
290	34	77	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
291	34	78	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
292	34	79	f	2025-06-22 17:52:33.695029+05:30	2025-06-22 17:52:33.695029+05:30	EMP-25-0001	EMP-25-0001
293	32	1	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
294	32	3	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
295	32	2	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
296	32	4	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
297	32	5	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
298	32	6	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
299	32	7	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
300	32	8	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
301	32	9	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
302	32	10	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
303	32	11	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
304	32	12	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
305	32	13	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
306	32	14	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
307	32	15	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
1408	4	45	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1393	4	37	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
308	32	18	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
309	32	19	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
310	32	20	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
311	32	21	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
312	32	22	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
313	32	23	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
314	32	24	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
315	32	25	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
316	32	26	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
317	32	27	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
318	32	28	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
319	32	29	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
320	32	30	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
321	32	31	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
322	32	32	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
323	32	33	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
324	32	34	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
325	32	35	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
326	32	36	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
327	32	37	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
328	32	38	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
329	32	39	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
330	32	40	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
331	32	41	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
332	32	42	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
333	32	43	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
334	32	44	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
335	32	45	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
337	32	47	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
339	32	48	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
341	32	49	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
343	32	50	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
336	32	46	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
345	32	51	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
346	32	52	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
347	32	53	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
348	32	54	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
349	32	55	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
350	32	56	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
351	32	57	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
352	32	58	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
353	32	59	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
354	32	60	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
355	32	61	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
356	32	62	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
357	32	63	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
359	32	69	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
1411	4	47	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
361	32	70	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
363	32	71	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
365	32	72	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
358	32	68	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
368	32	77	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
1413	4	48	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
370	32	78	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
367	32	73	t	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
372	32	79	f	2025-06-22 17:53:47.169529+05:30	2025-06-22 17:53:47.169529+05:30	EMP-25-0001	EMP-25-0001
1415	4	49	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1417	4	50	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1410	4	46	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1420	4	52	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1422	4	53	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1424	4	54	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1426	4	55	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1428	4	56	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1430	4	57	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1432	4	58	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1419	4	51	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1435	4	60	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1437	4	61	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1439	4	62	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1441	4	63	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1434	4	59	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1444	4	69	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1446	4	70	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1448	4	71	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1450	4	72	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1443	4	68	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1453	4	77	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1455	4	78	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1452	4	73	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1458	4	80	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
1457	4	79	t	2025-06-23 15:52:18.216276+05:30	2025-06-23 15:52:18.216276+05:30	EMP-25-0001	EMP-25-0001
\.


--
-- Data for Name: designations; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.designations (id, name, department_id, description, created_at, updated_at) FROM stdin;
1	SALES MANAGER	1	SALES MANAGER	2025-06-13 05:33:13.03+05:30	2025-06-13 05:33:13.03+05:30
2	SALES EXECUTIVE	1	SALES EXECUTIVE	2025-06-13 05:33:26.747+05:30	2025-06-13 05:33:26.747+05:30
3	SALES HEAD	1	SALES HEAD	2025-06-13 05:42:19.098+05:30	2025-06-13 05:42:19.098+05:30
4	MANAGING DIRECTOR	2	MANAGING DIRECTOR	2025-06-13 05:49:45.631+05:30	2025-06-13 05:49:45.631+05:30
5	CEO	2	CEO	2025-06-13 05:49:55.499+05:30	2025-06-13 05:49:55.499+05:30
6	ADMIN MANAGER	3	ADMIN MANAGER	2025-06-13 05:54:09.103+05:30	2025-06-13 05:54:19.744+05:30
9	BRANCH MANAGER	3	BRANCH MANAGER	2025-06-13 11:24:08.813+05:30	2025-06-13 11:29:55.319+05:30
13	BUSINESS DEVELOPMENT MANAGER	14	BUSINESS DEVELOPMENT MANAGER	2025-06-13 11:25:18.594+05:30	2025-06-13 11:30:02.013+05:30
18	CINEMATOGRAPHER	8	CINEMATOGRAPHER	2025-06-13 11:26:27.317+05:30	2025-06-13 11:30:11.684+05:30
7	EVENT COORDINATOR - MANAGER	5	EVENT COORDINATOR - MANAGER	2025-06-13 11:23:11.883+05:30	2025-06-13 11:30:23.594+05:30
20	FREELANCER	9	FREELANCER	2025-06-13 11:27:14.438+05:30	2025-06-13 11:30:34.986+05:30
14	HOUSE KEEPING	15	HOUSE KEEPING	2025-06-13 11:25:30.747+05:30	2025-06-13 11:36:45.323+05:30
12	HR MANAGER	10	HR MANAGER	2025-06-13 11:25:03.807+05:30	2025-06-13 11:36:55.031+05:30
19	INTERN	1	INTERN	2025-06-13 11:26:40.253+05:30	2025-06-13 11:37:03.904+05:30
16	POST PRODUCTION - MANAGER	6	POST PRODUCTION - MANAGER	2025-06-13 11:26:04.32+05:30	2025-06-13 11:37:59.698+05:30
10	RETOUCHER	13	RETOUCHER	2025-06-13 11:24:20.33+05:30	2025-06-13 11:38:17.139+05:30
8	SOCIAL MEDIA MANAGER	12	SOCIAL MEDIA MANAGER	2025-06-13 11:23:28.111+05:30	2025-06-13 11:38:30.339+05:30
11	TRADITIONAL PHOTOGRAPHER	7	TRADITIONAL PHOTOGRAPHER	2025-06-13 11:24:38.483+05:30	2025-06-13 11:38:44.113+05:30
17	TRADITIONAL VIDEOGRAPHER	9	TRADITIONAL VIDEOGRAPHER	2025-06-13 11:26:15.047+05:30	2025-06-13 11:38:53.749+05:30
21	DRIVER	15	DRIVER	2025-06-13 11:41:45.619+05:30	2025-06-13 11:41:45.619+05:30
22	DATA MANAGEMENT EXECUTIVE	11	DATA MANAGEMENT EXECUTIVE	2025-06-13 11:42:01.603+05:30	2025-06-13 11:42:01.603+05:30
23	ALBUM DESIGNER	6	ALBUM DESIGNER	2025-06-13 11:43:42.716+05:30	2025-06-13 11:43:42.716+05:30
24	POST PRODUCTION EXECUTIVE	6	POST PRODUCTION EXECUTIVE	2025-06-13 11:50:04.442+05:30	2025-06-13 11:50:04.442+05:30
25	CANDID VIDEO EDITOR	6	CANDID VIDEO EDITOR	2025-06-13 12:11:51.168+05:30	2025-06-13 12:11:51.168+05:30
26	SOCIAL MEDIA EXECUTIVE	12	SOCIAL MEDIA EXECUTIVE	2025-06-13 12:12:05.813+05:30	2025-06-13 12:12:05.813+05:30
27	SHOOT ASSIST	7	SHOOT ASSIST	2025-06-13 12:12:22.324+05:30	2025-06-13 12:12:22.324+05:30
28	INTERNSHIP	6	INTERNSHIP	2025-06-13 12:12:49.222+05:30	2025-06-13 12:12:49.222+05:30
29	QUALITY ANALYST	1	QUALITY ANALYST	2025-06-13 12:12:57.757+05:30	2025-06-13 12:12:57.757+05:30
30	CANDID VIDEOGRAPHER	9	CANDID VIDEOGRAPHER	2025-06-13 12:14:39.42+05:30	2025-06-13 12:14:39.42+05:30
31	TRADITIONAL VIDEO EDITOR	6	TRADITIONAL VIDEO EDITOR	2025-06-13 12:15:04.534+05:30	2025-06-13 12:17:27.679+05:30
15	VIDEO EDITOR EXECUTIVE	6	VIDEO EDITOR EXECUTIVE	2025-06-13 11:25:51.18+05:30	2025-06-13 12:17:44.869+05:30
32	ACCOUNTS MANAGER	4	ACCOUNTS MANAGER	2025-06-13 12:18:09.843+05:30	2025-06-13 12:18:09.843+05:30
33	ACCOUNTS ASSISTANT	4	\N	2025-06-13 12:18:21.074+05:30	2025-06-13 12:18:21.074+05:30
34	DATA MANAGER	11	DATA MANAGER	2025-06-13 12:44:02.633+05:30	2025-06-13 12:44:02.633+05:30
35	QUALITY ANALYST	21	QUALITY ANALYST	2025-06-13 13:26:49.79+05:30	2025-06-13 13:26:49.79+05:30
37	CANDID PHOTOGRAPHER	18	CANDID PHOTOGRAPHER	2025-06-13 15:37:07.3+05:30	2025-06-13 15:37:07.3+05:30
\.


--
-- Data for Name: dynamic_menus; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.dynamic_menus (id, menu_id, label, href, icon, description, parent_id, sort_order, is_active, created_at, updated_at) FROM stdin;
2	dashboard	Dashboard	/	Home	Main dashboard overview	\N	1	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
4	sales-revenue	Sales & Revenue	/sales	TrendingUp	Sales management and revenue tracking	\N	2	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
9	follow-up	Follow Up	/follow-ups	PhoneCall	Customer follow-up activities	\N	5	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
10	quotations	Quotations	/sales/quotations	FileText	Create and manage quotes	\N	6	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
12	rejected-quotes	Rejected Quotes	/sales/rejected-quotes	X	Declined quotations	\N	8	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
16	ai-business-insights	AI Business Insights	/ai/insights	Brain	AI-powered business analytics	\N	12	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
17	ai-call-analytics	AI Call Analytics	/ai/call-analytics	Phone	AI call performance analysis	\N	13	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
19	organization	Organization	/organization	Building2	Company structure and settings	\N	3	t	2025-06-11 05:47:09.46	2025-06-11 05:47:09.46
20	companies	Companies	/organization/companies	Building2	Manage companies	\N	1	t	2025-06-11 05:47:09.46	2025-06-11 05:47:09.46
21	branches	Branches	/organization/branches	MapPin	Company branch locations	\N	2	t	2025-06-11 05:47:09.46	2025-06-11 05:47:09.46
22	clients	Clients	/organization/clients	Users	Client management	\N	3	t	2025-06-11 05:47:09.46	2025-06-11 05:47:09.46
23	suppliers	Suppliers	/organization/suppliers	Truck	Supplier management	\N	4	t	2025-06-11 05:47:09.46	2025-06-11 05:47:09.46
24	vendors	Vendors	/organization/vendors	Store	Vendor relationships	\N	5	t	2025-06-11 05:47:09.46	2025-06-11 05:47:09.46
25	roles-permissions	Roles & Permissions	/organization/roles	Shield	User roles and access control	\N	6	t	2025-06-11 05:47:09.46	2025-06-11 05:47:09.46
26	user-accounts	User Accounts	/organization/user-accounts	Users	User account management	\N	7	t	2025-06-11 05:47:09.46	2025-06-11 05:47:09.46
28	people-hr	People & HR	/people	Users	Human resources management	\N	4	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
29	people-dashboard	People Dashboard	/people/dashboard	BarChart3	HR metrics and overview	\N	1	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
30	employees	Employees	/people/employees	Users	Employee management	\N	2	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
31	departments	Departments	/people/departments	Building2	Department structure	\N	3	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
32	designations	Designations	/people/designations	Target	Job roles and positions	\N	4	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
33	task-management	Task Management	/tasks	Target	Project and task coordination	\N	5	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
37	task-analytics	Task Analytics	/tasks/analytics	BarChart3	Task performance metrics	\N	4	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
38	task-calendar	Task Calendar	/tasks/calendar	Calendar	Schedule and timeline view	\N	5	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
40	task-reports	Task Reports	/tasks/reports	FileText	Task completion reports	\N	7	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
48	event-coordination	Event Coordination	/events	Calendar	Event planning and management	\N	7	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
49	events-dashboard	Events Dashboard	/events/dashboard	BarChart3	Event metrics overview	\N	1	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
50	event-calendar	Event Calendar	/events/calendar	Calendar	Event scheduling	\N	2	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
52	event-types	Event Types	/events/types	Tag	Event categorization	\N	4	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
53	services	Services	/events/services	Tool	Event services offered	\N	5	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
54	venues	Venues	/events/venues	MapPin	Event locations	\N	6	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
1	core-business	Core Business	#	LayoutGrid	Core business operations	\N	1	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
5	sales-dashboard	Sales Dashboard	/sales	BarChart3	Sales performance overview	\N	1	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
6	create-lead	Create Lead	/sales/create-lead	UserPlus	Add new potential customers	\N	2	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
7	my-leads	My Leads	/sales/my-leads	List	Your assigned leads	\N	3	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
8	unassigned-leads	Unassigned Leads	/sales/unassigned-lead	Users	Leads without assignment	\N	4	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
14	rejected-leads	Rejected Leads	/sales/rejected-leads	XCircle	Declined leads	\N	10	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
15	lead-sources	Lead Sources	/sales/lead-sources	Globe	Lead generation channels	\N	11	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
11	approval-queue	Approval Queue	/sales/approvals	Clock	Pending approvals	\N	7	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
13	order-confirmation	Order Confirmation	/sales/order-confirmation	Check	Confirmed orders	\N	9	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
18	sales-head-analytics	Sales Head Analytics	/sales-head-analytics	TrendingUp	Executive sales insights	\N	14	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
27	account-creation	Account Creation	/organization/account-creation	UserPlus	Create new user accounts	\N	8	t	2025-06-11 05:47:09.46	2025-06-11 05:47:09.46
34	my-tasks	My Tasks	/tasks/dashboard	CheckSquare	Your assigned tasks	\N	1	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
35	task-control-center	Task Control Center	/admin/task-management	Settings	Central task management	\N	2	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
39	migration-panel	Migration Panel	/admin/migration	ArrowRightLeft	Data migration tools	\N	6	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
41	task-sequence-management	Task Sequence Management	/admin/task-sequences	GitBranch	Workflow sequencing	\N	8	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
42	integration-status	Integration Status	/tasks/integration	Link	System integration monitoring	\N	9	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
36	ai-task-generator	AI Task Generator	/admin/task-management	Zap	AI-powered task creation	\N	3	t	2025-06-11 05:47:09.461	2025-06-11 05:47:09.461
46	payments	Payments	/accounting/payments	CreditCard	Payment processing	\N	3	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
43	accounting-finance	Accounting & Finance	/accounting/payments	Calculator	Financial management	\N	6	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
45	invoices	Invoices	/sales/quotations/analytics	FileText	Invoice management	\N	2	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
47	expenses	Expenses	/sales/quotations/analytics	Receipt	Expense tracking	\N	4	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
51	events	Events	/events	Star	Event listings	\N	3	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
55	staff-assignment	Staff Assignment	/events/staff-assignment	Users	Event staffing	\N	7	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
56	post-production	Post Production	/post-production/deliverables	Film	Production workflow management	\N	8	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
70	reports-analytics	Reports & Analytics	/reports	BarChart3	Business intelligence and reporting	\N	10	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
71	lead-source-analysis	Lead Source Analysis	/reports/lead-sources	Globe	Lead generation analytics	\N	1	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
72	conversion-funnel	Conversion Funnel	/reports/funnel	TrendingUp	Sales conversion analysis	\N	2	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
73	team-performance	Team Performance	/reports/team	Users	Team productivity metrics	\N	3	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
74	business-trends	Business Trends	/reports/trends	TrendingUp	Market trend analysis	\N	4	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
75	custom-reports	Custom Reports	/reports/custom	FileText	Customizable reporting	\N	5	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
76	system-administration	System Administration	/admin	Shield	System configuration and management	\N	11	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
77	menu-manager	Menu Manager	/organization/menu-manager	Menu	Dynamic menu management	\N	1	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
3	ai-business-control	AI Business Control	/control	Zap	AI-powered business automation	\N	2	t	2025-06-11 05:47:09.459	2025-06-11 05:47:09.459
44	financial-dashboard	Financial Dashboard	/sales/quotations/analytics	BarChart3	Financial overview	\N	1	t	2025-06-11 05:47:09.462	2025-06-11 05:47:09.462
58	deliverables	Deliverables	/post-production/deliverables	Package	Project deliverables	\N	2	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
59	deliverables-workflow	Deliverables Workflow	/post-production/deliverables-workflow	GitBranch	Delivery process flow	\N	3	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
57	production-dashboard	Production Dashboard	/post-production/deliverables	BarChart3	Production metrics	\N	1	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
60	projects	Projects	/post-production/deliverables	Folder	Production projects	\N	4	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
61	workflow	Workflow	/post-production/deliverables	Shuffle	Process management	\N	5	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
62	quality-control	Quality Control	/post-production/deliverables	CheckCircle	Quality assurance	\N	6	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
63	client-review	Client Review	/post-production/deliverables	Eye	Client feedback process	\N	7	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
64	final-delivery	Final Delivery	/post-production/deliverables	Send	Project completion	\N	8	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
65	post-sales	Post-Sales	/post-sales/confirmations	Handshake	After-sales customer service	\N	9	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
66	post-sales-dashboard	Post-Sales Dashboard	/post-sales/confirmations	BarChart3	Post-sales metrics	\N	1	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
67	delivery-management	Delivery Management	/post-sales/confirmations	Truck	Delivery coordination	\N	2	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
68	customer-support	Customer Support	/post-sales/confirmations	HeadphonesIcon	Customer assistance	\N	3	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
69	customer-feedback	Customer Feedback	/post-sales/confirmations	MessageSquare	Customer satisfaction	\N	4	t	2025-06-11 05:47:09.463	2025-06-11 05:47:09.463
\.


--
-- Data for Name: email_notification_templates; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.email_notification_templates (id, name, subject, html_template, text_template, variables, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: employee_companies; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.employee_companies (id, employee_id, company_id, branch_id, allocation_percentage, is_primary, created_at, updated_at, start_date, end_date, project_id, status) FROM stdin;
1	22	2	1	100	f	2025-06-13 05:34:17.951+05:30	2025-06-13 05:34:17.951+05:30	\N	\N	\N	active
2	6	2	1	100	t	2025-06-13 05:35:26.27+05:30	2025-06-13 05:35:40.222+05:30	\N	\N	\N	active
3	7	2	1	100	t	2025-06-13 05:43:14.297+05:30	2025-06-13 05:43:36.473+05:30	\N	\N	\N	active
4	1	2	1	100	f	2025-06-13 05:50:16.485+05:30	2025-06-13 05:50:16.485+05:30	\N	\N	\N	active
5	2	2	1	100	f	2025-06-13 05:51:56.413+05:30	2025-06-13 05:51:56.413+05:30	\N	\N	\N	active
6	3	2	1	100	f	2025-06-13 05:55:08.58+05:30	2025-06-13 05:55:08.58+05:30	\N	\N	\N	active
9	10	2	1	100	t	2025-06-13 12:56:50.081+05:30	2025-06-13 13:08:27.585+05:30	\N	\N	\N	active
8	9	2	1	100	t	2025-06-13 12:51:22.031+05:30	2025-06-13 13:08:36.492+05:30	\N	\N	\N	active
7	8	2	1	100	t	2025-06-13 12:44:48.319+05:30	2025-06-13 13:08:57.202+05:30	\N	\N	\N	active
10	11	2	1	100	t	2025-06-13 13:29:03.828+05:30	2025-06-13 13:29:03.828+05:30	\N	\N	\N	active
11	12	2	1	100	t	2025-06-13 13:30:06.578+05:30	2025-06-13 13:30:06.578+05:30	\N	\N	\N	active
12	15	2	1	100	t	2025-06-13 13:35:39.883+05:30	2025-06-13 13:35:39.883+05:30	\N	\N	\N	active
13	16	2	1	100	t	2025-06-13 13:37:16.828+05:30	2025-06-13 13:37:16.828+05:30	\N	\N	\N	active
14	17	2	1	100	t	2025-06-13 13:38:25.951+05:30	2025-06-13 13:38:25.951+05:30	\N	\N	\N	active
15	18	2	1	100	t	2025-06-13 14:25:58.812+05:30	2025-06-13 14:25:58.812+05:30	\N	\N	\N	active
16	19	2	1	100	t	2025-06-13 14:27:54.818+05:30	2025-06-13 14:27:54.818+05:30	\N	\N	\N	active
17	20	2	1	100	t	2025-06-13 14:29:03.995+05:30	2025-06-13 14:29:03.995+05:30	\N	\N	\N	active
18	21	\N	\N	100	t	2025-06-13 14:34:32.036+05:30	2025-06-13 14:34:32.036+05:30	\N	\N	\N	active
19	23	2	1	100	t	2025-06-13 14:38:34.359+05:30	2025-06-13 14:38:34.359+05:30	\N	\N	\N	active
20	24	2	1	100	t	2025-06-13 14:42:51.49+05:30	2025-06-13 14:42:51.49+05:30	\N	\N	\N	active
21	25	2	1	100	t	2025-06-13 14:56:45.493+05:30	2025-06-13 14:56:45.493+05:30	\N	\N	\N	active
22	26	2	1	100	t	2025-06-13 15:09:03.855+05:30	2025-06-13 15:09:03.855+05:30	\N	\N	\N	active
23	27	2	1	100	t	2025-06-13 15:11:11.078+05:30	2025-06-13 15:11:11.078+05:30	\N	\N	\N	active
24	28	2	1	100	t	2025-06-13 15:19:01.229+05:30	2025-06-13 15:19:01.229+05:30	\N	\N	\N	active
25	29	2	1	100	t	2025-06-13 15:20:31.857+05:30	2025-06-13 15:20:31.857+05:30	\N	\N	\N	active
26	30	2	1	100	t	2025-06-13 15:29:34.264+05:30	2025-06-13 15:29:34.264+05:30	\N	\N	\N	active
27	31	2	1	100	t	2025-06-13 15:30:46.424+05:30	2025-06-13 15:30:46.424+05:30	\N	\N	\N	active
28	32	2	1	100	t	2025-06-13 15:31:50.737+05:30	2025-06-13 15:31:50.737+05:30	\N	\N	\N	active
29	33	2	1	100	t	2025-06-13 15:32:57.075+05:30	2025-06-13 15:32:57.075+05:30	\N	\N	\N	active
30	34	2	1	100	t	2025-06-13 15:34:10.831+05:30	2025-06-13 15:34:10.831+05:30	\N	\N	\N	active
31	35	2	1	100	t	2025-06-13 15:35:19.775+05:30	2025-06-13 15:35:19.775+05:30	\N	\N	\N	active
32	36	2	1	100	t	2025-06-13 15:41:11.759+05:30	2025-06-13 15:41:11.759+05:30	\N	\N	\N	active
33	37	2	1	100	t	2025-06-13 15:42:26.748+05:30	2025-06-13 15:42:26.748+05:30	\N	\N	\N	active
34	38	2	1	100	t	2025-06-13 15:43:29.039+05:30	2025-06-13 15:43:29.039+05:30	\N	\N	\N	active
35	39	2	1	100	t	2025-06-13 15:44:41.832+05:30	2025-06-13 15:44:41.832+05:30	\N	\N	\N	active
36	40	2	1	100	t	2025-06-13 15:45:39.858+05:30	2025-06-13 15:45:39.858+05:30	\N	\N	\N	active
37	41	2	1	100	t	2025-06-13 15:46:48.835+05:30	2025-06-13 15:46:48.835+05:30	\N	\N	\N	active
38	42	2	1	100	t	2025-06-13 15:49:00.656+05:30	2025-06-13 15:49:00.656+05:30	\N	\N	\N	active
39	43	2	1	100	t	2025-06-13 15:50:18.91+05:30	2025-06-13 15:50:18.91+05:30	\N	\N	\N	active
40	44	2	1	100	t	2025-06-13 15:51:41.562+05:30	2025-06-13 15:51:41.562+05:30	\N	\N	\N	active
41	45	2	1	100	t	2025-06-13 15:53:18.559+05:30	2025-06-13 15:53:18.559+05:30	\N	\N	\N	active
42	46	4	5	100	t	2025-06-13 16:02:46.708+05:30	2025-06-13 16:02:46.708+05:30	\N	\N	\N	active
43	47	2	4	100	t	2025-06-13 16:04:36.965+05:30	2025-06-13 16:04:36.965+05:30	\N	\N	\N	active
44	48	2	1	100	t	2025-06-13 16:07:16.906+05:30	2025-06-13 16:07:16.906+05:30	\N	\N	\N	active
45	49	3	2	100	t	2025-06-13 16:09:03.938+05:30	2025-06-13 16:09:03.938+05:30	\N	\N	\N	active
\.


--
-- Data for Name: employee_devices; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.employee_devices (id, employee_id, device_id, fcm_token, device_name, platform, app_version, is_active, last_seen, created_at, updated_at) FROM stdin;
4	EMP-25-0001	test_device_001	sample_fcm_token_for_testing	Admin Phone	android	1.0.0	t	2025-06-16 16:50:24.57+05:30	2025-06-16 16:47:35.688+05:30	2025-06-16 16:50:24.575+05:30
6	EMP-25-0001	test_device_fresh_1750073678901	android_device_1750073678901	Vikas Phone (Galaxy)	android	1.1.0	t	2025-06-16 17:04:31.105+05:30	2025-06-16 17:04:31.112+05:30	2025-06-16 17:04:31.112+05:30
7	EMP-25-0001	test_android_device_1750074307504	android_device_1750074307504	Vikas's Phone (Android)	android	1.1.0	t	2025-06-16 17:15:07.511+05:30	2025-06-16 17:15:07.511+05:30	2025-06-16 17:15:07.511+05:30
8	EMP-25-0001	ANDROID_admin_1750074625487_1750074626132	android_device_1750074626132	Vikas's Phone (Android)	android	1.1.0	t	2025-06-16 17:20:26.138+05:30	2025-06-16 17:20:26.138+05:30	2025-06-16 17:20:26.138+05:30
9	EMP-25-0001	test_android_device_1750079030253	android_device_1750079030253	Vikas's Phone (Android)	android	1.1.0	t	2025-06-16 18:33:50.26+05:30	2025-06-16 18:33:50.26+05:30	2025-06-16 18:33:50.26+05:30
10	EMP-25-0001	test_localhost_1750079114524	android_device_1750079114524	Vikas's Phone (Android)	android	1.1.0	t	2025-06-16 18:35:14.526+05:30	2025-06-16 18:35:14.526+05:30	2025-06-16 18:35:14.526+05:30
11	EMP-25-0001	ANDROID_admin_1750079886976_1750079887226	android_device_1750079887226	Vikas's Phone (Android)	android	1.1.0	t	2025-06-16 18:48:07.232+05:30	2025-06-16 18:48:07.232+05:30	2025-06-16 18:48:07.232+05:30
12	EMP-25-0001	ANDROID_admin_1750080717835_1750080717884	android_device_1750080717884	Vikas's Phone (Android)	android	1.1.0	t	2025-06-16 19:01:57.89+05:30	2025-06-16 19:01:57.89+05:30	2025-06-16 19:01:57.89+05:30
13	EMP-25-0001	ANDROID_admin_1750082778775_1750082779476	android_device_1750082779476	Vikas's Phone (Android)	android	1.1.0	t	2025-06-16 19:36:19.478+05:30	2025-06-16 19:36:19.478+05:30	2025-06-16 19:36:19.478+05:30
14	EMP-25-0001	ANDROID_admin_1750083032415_1750083032515	android_device_1750083032515	Vikas's Phone (Android)	android	1.1.0	t	2025-06-16 19:40:32.52+05:30	2025-06-16 19:40:32.52+05:30	2025-06-16 19:40:32.52+05:30
15	EMP-25-0001	ANDROID_admin_1750089213333_1750089213468	android_device_1750089213468	Vikas's Phone (Android)	android	1.1.0	t	2025-06-16 21:23:33.473+05:30	2025-06-16 21:23:33.473+05:30	2025-06-16 21:23:33.473+05:30
16	EMP-25-0001	aef21d11c36e3b2e_1750121953519	android_device_1750121953519	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 06:29:13.525+05:30	2025-06-17 06:29:13.525+05:30	2025-06-17 06:29:13.525+05:30
17	EMP-25-0001	aef21d11c36e3b2e_1750124475036	android_device_1750124475036	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 07:11:15.042+05:30	2025-06-17 07:11:15.042+05:30	2025-06-17 07:11:15.042+05:30
18	EMP-25-0001	aef21d11c36e3b2e_1750130620649	android_device_1750130620649	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 08:53:40.656+05:30	2025-06-17 08:53:40.656+05:30	2025-06-17 08:53:40.656+05:30
19	EMP-25-0001	aef21d11c36e3b2e_1750134079701	android_device_1750134079701	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 09:51:19.705+05:30	2025-06-17 09:51:19.705+05:30	2025-06-17 09:51:19.705+05:30
20	EMP-25-0001	aef21d11c36e3b2e_1750137991922	android_device_1750137991922	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 10:56:31.926+05:30	2025-06-17 10:56:31.926+05:30	2025-06-17 10:56:31.926+05:30
21	EMP-25-0001	aef21d11c36e3b2e_1750139844805	android_device_1750139844805	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 11:27:24.807+05:30	2025-06-17 11:27:24.807+05:30	2025-06-17 11:27:24.807+05:30
22	EMP-25-0001	aef21d11c36e3b2e_1750139857716	android_device_1750139857716	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 11:27:37.717+05:30	2025-06-17 11:27:37.717+05:30	2025-06-17 11:27:37.717+05:30
23	EMP-25-0001	aef21d11c36e3b2e_1750140239836	android_device_1750140239836	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 11:33:59.84+05:30	2025-06-17 11:33:59.84+05:30	2025-06-17 11:33:59.84+05:30
24	EMP-25-0001	aef21d11c36e3b2e_1750140372366	android_device_1750140372366	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 11:36:12.372+05:30	2025-06-17 11:36:12.372+05:30	2025-06-17 11:36:12.372+05:30
25	EMP-25-0001	aef21d11c36e3b2e_1750141876135	android_device_1750141876135	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 12:01:16.137+05:30	2025-06-17 12:01:16.137+05:30	2025-06-17 12:01:16.137+05:30
26	EMP-25-0001	aef21d11c36e3b2e_1750141888009	android_device_1750141888009	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 12:01:28.01+05:30	2025-06-17 12:01:28.01+05:30	2025-06-17 12:01:28.01+05:30
58	EMP-25-0001	test-device-123_1750148730554	android_device_1750148730554	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 13:55:30.559+05:30	2025-06-17 13:55:30.559+05:30	2025-06-17 13:55:30.559+05:30
59	EMP-25-0001	test-device-123_1750148736524	android_device_1750148736524	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 13:55:36.529+05:30	2025-06-17 13:55:36.529+05:30	2025-06-17 13:55:36.529+05:30
60	EMP-25-0001	aef21d11c36e3b2e_1750149346025	android_device_1750149346025	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 14:05:46.027+05:30	2025-06-17 14:05:46.027+05:30	2025-06-17 14:05:46.027+05:30
61	EMP-25-0002	aef21d11c36e3b2e_1750149400767	android_device_1750149400767	Pradeep's Phone (Android)	android	1.1.0	t	2025-06-17 14:06:40.771+05:30	2025-06-17 14:06:40.771+05:30	2025-06-17 14:06:40.771+05:30
62	EMP-25-0001	aef21d11c36e3b2e_1750149422950	android_device_1750149422950	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 14:07:02.951+05:30	2025-06-17 14:07:02.951+05:30	2025-06-17 14:07:02.951+05:30
63	EMP-25-0001	aef21d11c36e3b2e_1750149847185	android_device_1750149847185	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 14:14:07.187+05:30	2025-06-17 14:14:07.187+05:30	2025-06-17 14:14:07.187+05:30
64	EMP-25-0001	aef21d11c36e3b2e_1750150518649	android_device_1750150518649	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 14:25:18.651+05:30	2025-06-17 14:25:18.651+05:30	2025-06-17 14:25:18.651+05:30
65	EMP-25-0001	aef21d11c36e3b2e_1750164054012	android_device_1750164054012	Vikas's Phone (Android)	android	1.1.0	t	2025-06-17 18:10:54.014+05:30	2025-06-17 18:10:54.014+05:30	2025-06-17 18:10:54.014+05:30
66	EMP-25-0004	aef21d11c36e3b2e_1750172968810	android_device_1750172968810	Sridhar's Phone (Android)	android	1.1.0	t	2025-06-17 20:39:28.815+05:30	2025-06-17 20:39:28.815+05:30	2025-06-17 20:39:28.815+05:30
67	EMP-25-0001	test_android_123	updated_fcm_token	Test Android	android	1.2.0	t	2025-06-19 09:50:16.92+05:30	2025-06-19 09:50:10.371+05:30	2025-06-19 09:50:16.92+05:30
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.employees (id, employee_id, first_name, last_name, email, phone, address, city, state, zip_code, country, hire_date, termination_date, status, department_id, designation_id, job_title, home_branch_id, primary_company_id, created_at, updated_at, name, username, password_hash, role_id, last_login, is_active) FROM stdin;
8	EMP-25-0007	RAHAMATHULLAH 	KHAN	khanrahamat@yahoo.com	09677362524	NO-2, DARKHA CROSS STREET, DASHAMAKKAN, CHENNAI-600012	Chennai	Tamil Nadu	600040	India	\N	\N	active	11	34	DATA MANAGER	1	2	2025-06-13 12:44:48.313+05:30	2025-06-13 13:08:57.194+05:30	\N	\N	\N	\N	\N	t
10	EMP-25-0009	RICHFIELD 	ANESTON	123@gmail.com	8072138412	MIG FLATS, 49, BHARATHIDHASAN COLONY, K.K NAGAR, CHENNAI - 600078 (RENT HOUSE)	\N	\N	\N	\N	\N	\N	active	15	14	HOUSE KEEPING	1	2	2025-06-13 12:56:50.077+05:30	2025-06-13 13:08:27.575+05:30	\N	\N	\N	\N	\N	t
11	EMP-25-0010	SAM 	VIKASH	shyamvikash46@gmail.com	9176798723	NO: 26, 2ND CROSS STREET, JOTHIAMMA NAGAR, SHENOY NAGAR, CHENNAI - 600030\r\nJAI NAGAR, ARUMBAKKAM, CHENNAI - 600106	\N	\N	\N	\N	\N	\N	active	21	35	QUALITY ANALYST	1	2	2025-06-13 13:29:03.825+05:30	2025-06-13 13:29:03.825+05:30	\N	\N	\N	\N	\N	t
12	EMP-25-0011	BHARATHI KANNAN 	N	nbk.mca@gmail.com	6374110704	NO: 8, ANNAI INDHRA NAGAR, RAMAPURAM HIGH ROAD, NESAPAKAM, CHENNAI - 600078 (RENTAL) RESIDING PAST 3 YEARS WITH PARENTS	\N	\N	\N	\N	\N	\N	active	11	22	DATA MANAGEMENT EXECUTIVE	1	2	2025-06-13 13:30:06.574+05:30	2025-06-13 13:30:06.574+05:30	\N	\N	\N	\N	\N	t
15	EMP-25-0012	REVANTH	A	1234@gmail.com	7904348108	\N	\N	\N	\N	\N	\N	\N	active	21	35	QUALITY ANALYST	1	2	2025-06-13 13:35:39.879+05:30	2025-06-13 13:35:39.879+05:30	\N	\N	\N	\N	\N	t
16	EMP-25-0013	SURYA	M	1231@gmail.com	8122594308	36, BAJANAI STREET, ARUMBAKKAM, NADUVANKARAI, CHENNAI	\N	\N	\N	\N	\N	\N	active	6	15	VIDEO EDITOR	1	2	2025-06-13 13:37:16.824+05:30	2025-06-13 13:37:16.824+05:30	\N	\N	\N	\N	\N	t
17	EMP-25-0014	PRANEETH 	ANNAIRAJ	\N	6369323601	569, J BLOCK, SUTHATHIRA NAGAR, MOORS ROAD, THOUSAND LIGHTS, CHENNAI - 600 006\r\n	\N	\N	\N	\N	\N	\N	active	6	23	ALBUM DESIGNER	1	2	2025-06-13 13:38:25.947+05:30	2025-06-13 13:38:25.947+05:30	\N	\N	\N	\N	\N	t
18	EMP-25-0015	VISHWA	S	VISCOMVISHWA@GMAIL.COM	9363522772	77/75, PILLAIYAR KOIL STREET, NARASINGAPURAM, AATHUR TALUK, SALEM - 636108\r\n\r\n14G, D BLOCK, ALS GARDEN, DHANALAKSHMY COLONY, NATARAJAN STREET, VADAPALANI -CHENNAI - 600 026\r\n	\N	\N	\N	\N	\N	\N	active	6	15	VIDEO EDITOR	1	2	2025-06-13 14:25:58.808+05:30	2025-06-13 14:25:58.808+05:30	\N	\N	\N	\N	\N	t
19	EMP-25-0016	MANIKANDAN 	PAVUNRAJ	PVMANIKANDAN05@GMAIL.COM	9047435578	754/1, COLONY STREET, MANNULI, THELUR, ARIYALUR, PERIYANAGALUR, TAMILNADU - 621704\r\n7/68, ERIKKARAI STREET, KADAPERRI, WEST TAMABARAM, CHENNAI - 600045\r\n	\N	\N	\N	\N	\N	\N	active	7	11	TRADITIONAL PHOTOGRAPHER	1	2	2025-06-13 14:27:54.815+05:30	2025-06-13 14:27:54.815+05:30	\N	\N	\N	\N	\N	t
20	EMP-25-0017	MADHAN RAJ	 K	MADHANRAM0604@GMAIL.COM	9092390604	15, VINAYAGAR STREET, BAKTHVATCHALA(BV) PURAM, AVADI, CHENNAI - 600 054	\N	\N	\N	\N	\N	\N	active	21	35	QUALITY ANALYST	1	2	2025-06-13 14:29:03.988+05:30	2025-06-13 14:29:03.988+05:30	\N	\N	\N	\N	\N	t
21	EMP-25-0018	SARANDEEP	S	SARANDEEP500@GMAIL.COM	6380625223	60, MARIYAMMAN KOVIL STREET, INDILI, ULAGAMKATHAN, VILUPPURAM - 606213\r\n\r\n23/7, SHANMUGASUNDARAM STREET, MUTHAMIZH NAGAR, SALIGRAMAM, CHENNAI - 600093\r\n	\N	\N	\N	\N	\N	\N	active	6	15	VIDEO EDITOR	\N	\N	2025-06-13 14:34:32.031+05:30	2025-06-13 14:34:32.031+05:30	\N	\N	\N	\N	\N	t
23	EMP-25-0019	PRABAGARAN	K	MKPRABA16012002@GMAIL.COM	9751424144	22, VEERAN KALANI, NINNIYUR, SENDURAI POST, ARIYALUR - 621714\r\n25, 18TH STREET, VS PURAM, SHENOY NAGAR,  CHENNAI - 600 030\r\n	\N	\N	\N	\N	\N	\N	active	7	27	SHOOT ASIST	1	2	2025-06-13 14:38:34.354+05:30	2025-06-13 14:38:34.354+05:30	\N	\N	\N	\N	\N	t
24	EMP-25-0020	YOGALAKSHMI	S	YOGALAKSHMII1997@GMAIL.COM	7904542041	6-4-144 Saibaba nagar, Aramghar, Rajendra Nagar,  Hyderabad500077	\N	\N	\N	\N	\N	\N	active	5	7	EVENT COORDINATOR - MANAGER	1	2	2025-06-13 14:42:51.484+05:30	2025-06-13 14:42:51.484+05:30	\N	\N	\N	\N	\N	t
25	EMP-25-0021	KIRUPANITHI	N	KIRUPANITHIMOORTHY@GMAIL.COM	6382092563	503, MARIYAMMAN KOVIL STREET, NALLAVUR POST, VAANUR TALUK, VILLUPURAM -604154\r\n15/50 trustpuram 10th street Kodambakkam Chennai 24	\N	\N	\N	\N	\N	\N	active	7	27	SHOOT ASSIST	1	2	2025-06-13 14:56:45.488+05:30	2025-06-13 14:56:45.488+05:30	\N	\N	\N	\N	\N	t
26	EMP-25-0022	ALAN 	JONES	DJALANJONES.JONES@GMAIL.COM	9677769776	OLD NO - 22C, NEW NO - 29, WILLIAMS ROAD CANTONMENT, TIRCHY - 620001\r\n\r\nF2 , first floor, Shivam apartments, Kings Avenue, Millennium Town, Adayalampattu, Maduravoyal, Chennai - 600095.	\N	\N	\N	\N	\N	\N	active	9	30	CANDID VIDEOGRAPHER	1	2	2025-06-13 15:09:03.852+05:30	2025-06-13 15:09:03.852+05:30	\N	\N	\N	\N	\N	t
9	EMP-25-0008	ASHARUDEEN	ABBAS	feroz.munna@yahoo.com	9789819592	16/2, 1ST LANE, MADHAVARAM HIGH ROAD NORTH, PERAMBUR, CHENNAI-600011	Chennai	Tamil Nadu	600040	India	\N	\N	active	4	32	ACCOUNTS MANAGER	1	2	2025-06-13 12:51:22.027+05:30	2025-06-13 13:08:36.484+05:30	\N	\N	$2b$12$5duiA0aLzbaRtsvXnXTB6ey/P08k2PHe9VtbZBEWCRjJKdf10w54a	\N	\N	t
3	EMP-25-0003	Dhinakaran	Bose	manager@company.com	09677362524	TAISHA, AIS Apartment Complex\r\n'G' Block 6th floor door no 3	Chennai	Tamilnadu	600092	India	\N	\N	active	3	6	Manager	1	2	2025-06-11 16:49:38.372+05:30	2025-06-18 08:49:50.584+05:30	Manager User	manager	$2b$10$gndW3GzDQxbxp0oxywLCLuKU0sWxhm13xL7XQlnnwZKgUVaYDlaCu	8	2025-06-12 22:36:54.731	t
22	EMP-25-0006	DEEPIKA	DEVI M	deepikadevimurali@gmail.com	\N	10/63, AZHAGIRI STREET, MGR NAGAR, CHENNAI - 600078 \r\n	\N	\N	\N	\N	\N	\N	active	1	2	SOCIAL MEDIA EXECUTIVE	1	2	2025-06-12 22:17:56.8+05:30	2025-06-18 08:49:50.584+05:30	\N	deepikadevimurali	$2b$10$kjr9dM.VW2D5iDvjvJhQ5uNVCe.gqsBtHyJUb4btBJxHt5G6Fno9u	2	2025-06-17 19:38:21.782	t
6	EMP-25-0004	Sridhar	k	rasvickys@gmail.com	09677362524	Bairavi Cruz Luxor, A-404, Chelekere Main road, Opp to st. rock  church, behind kalyan nagar bus depot	Bangalore	Karnataka	560043	India	\N	\N	active	1	1	SALES MANAGER	1	2	2025-06-13 05:35:26.265+05:30	2025-06-18 17:45:18.603+05:30	\N	rasvickys	$2b$10$ImJWD9X9a2Iphl9BulmR4uP2fMoZc7QMfO7YtwWLB70X38vQeX2Cu	7	2025-06-18 06:45:18.601	t
27	EMP-25-0023	SANTHOSH	N	SANTHOSH170787@GMAIL.COM	9962258052	OLD NO 5/3, NEW NO. 2/3, DEVAKI AMMAL STREET, SUPREME FLATS, PERAVALLUR, CHENNAI - 600082	\N	\N	\N	\N	\N	\N	active	6	16	POST PRODUCTION MANAGER	1	2	2025-06-13 15:11:11.075+05:30	2025-06-13 15:11:11.075+05:30	\N	\N	\N	\N	\N	t
29	EMP-25-0025	VIDHYASAGAR	P	appu54y12345@gmail.com	6380415460	23A, 3RD CROSS STREET, KRISHNA NAGAR, MADURAVOYAL - CHENNAI - 600095	\N	\N	\N	\N	\N	\N	active	7	11	TRADITIONAL PHOTOGRAPHER	1	2	2025-06-13 15:20:31.852+05:30	2025-06-13 15:20:31.852+05:30	\N	\N	\N	\N	\N	t
28	EMP-25-0024	SHOBANA	G	SHOBAG730@GMAIL.COM	8925348987	2/2975, NEHRU NAGAR 2ND STREET, VAIRAVAPURAM, KARAIKUDI - 630003\r\n22, VASANTHA PURAM, KAMACHI AMMAN LAYOUT. AYYAPANTHANGAL, CHENNAI - 600056	\N	\N	\N	\N	\N	\N	active	6	23	ALBUM DESIGNER	1	2	2025-06-13 15:19:01.224+05:30	2025-06-13 15:19:01.224+05:30	\N	\N	\N	\N	\N	t
30	EMP-25-0026	PREM CHANDAR	B	PREMCHAN309@GMAIL.COM	7904343078	36,EZHIL NAGAR, B- BLOCK, 4TH STREET, KODUNGAIYUR, CHENNAI - 600118	\N	\N	\N	\N	\N	\N	active	6	25	CANDID VIDEO EDITOR	1	2	2025-06-13 15:29:34.252+05:30	2025-06-13 15:29:34.252+05:30	\N	\N	\N	\N	\N	t
32	EMP-25-0028	KASHIF ALI	M	KASHIFALIRAZA2003@GMAIL.COM	6382836072	1/85, NAIDU STREET, RAMAPURAM, CHENNAI - 600089	\N	\N	\N	\N	\N	\N	active	6	15	VIDEO EDITOR	1	2	2025-06-13 15:31:50.73+05:30	2025-06-13 15:31:50.73+05:30	\N	\N	\N	\N	\N	t
33	EMP-25-0029	GEORGE PRASSANA KUMAR 	ERNEST	GEORGEPRASANNA1@GMAIL.COM	8072810976	103/32, VIJAYAKUMAR VILLA, F2, KAMARAJAR SALAI, SASTRI NAGAR, KODUNGAIYUR, CHENNAI - 600118	\N	\N	\N	\N	\N	\N	active	13	10	RETOUCHER	1	2	2025-06-13 15:32:57.068+05:30	2025-06-13 15:32:57.068+05:30	\N	\N	\N	\N	\N	t
7	EMP-25-0005	Durga	Devi	durga.ooak@gmail.com	09500999861	15/34, Thirumangalam Road, Navalar Nagar, Anna Nagar West,	Chennai	Tamil Nadu	600040	India	\N	\N	active	1	3	SALES HEAD	1	2	2025-06-13 05:43:14.29+05:30	2025-06-18 08:49:50.584+05:30	\N	durga.ooak	$2b$12$LeSYtWwnukxlHwyubis6iOlwFXRzq0Ko4SWGC1tOKx7GykoAaKa86	4	2025-06-17 10:57:46.795	t
2	EMP-25-0002	Pradeep	Ravi	pradeep@company.com	\N	\N	\N	\N	\N	\N	\N	\N	active	2	5	CEO	1	2	2025-06-11 16:49:38.372+05:30	2025-06-18 08:49:50.584+05:30	Pradeep Sales	pradeep	$2b$12$/OPMgZ0Rs2PL6nT07U9gSeoj9MVBOdoeCtkjlXejw5DblX1xceDUu	2	2025-06-12 18:28:28.011	t
34	EMP-25-0030	ANBU SELVAN	M	ANBUINBA19@GMAIL.COM	9360747167	704F/12, GANDHI NAGAR, MALAIYADIPATTI, RAJAPALAYAM, VIRUDHUNAGAR - 626117	\N	\N	\N	\N	\N	\N	active	6	25	CANDID VIDEO EDITOR	1	2	2025-06-13 15:34:10.821+05:30	2025-06-13 15:34:10.821+05:30	\N	\N	\N	\N	\N	t
35	EMP-25-0031	KATHIRVEL	G	KATH82459@GMAIL.COM	8610494189	131/A10-412, KAMARAJ NAGAR, RAJAPALAYAM, VIRUDHUNAGAR - 626117	\N	\N	\N	\N	\N	\N	active	7	27	SHOOT ASSIST	1	2	2025-06-13 15:35:19.768+05:30	2025-06-13 15:35:19.768+05:30	\N	\N	\N	\N	\N	t
36	EMP-25-0032	RAGESHHKHANNA	S	RAGESHHKHANNALATHA007@GMAIL.COM	8220587844	17A, SEETHALAKSHMIPURAM STREET, GOBICHETTIYPALAYAM, MODACHUR, ERODE - 638476\r\n\r\n#1, GT NAIDU 1ST STREER, GOMATHI NAGAR, CHITLAPAKKAM, SELAIYUR, CHENNAI - 600078	\N	\N	\N	\N	\N	\N	active	18	37	CANDID PHOTOGRAPHER	1	2	2025-06-13 15:41:11.748+05:30	2025-06-13 15:41:11.748+05:30	\N	\N	\N	\N	\N	t
37	EMP-25-0033	AJEETHKUMAR 	M.K	kajeeth513@gmail.com	7338778423	57/71, GANGAIAMMAN KOVIL STREET, KOLATHUR, CHENNAI - 600099	\N	\N	\N	\N	\N	\N	active	18	37	CANDID PHOTOGRAPHER	1	2	2025-06-13 15:42:26.739+05:30	2025-06-13 15:42:26.739+05:30	\N	\N	\N	\N	\N	t
38	EMP-25-0034	VIGNESH	V	VIGNESHVEERAMANI173@GMAIL.COM	8270756566	95A, PALAIYAKARA STREET, PERIYAPALAYAM, TIRUVALLUR, - 601102\r\n\r\nNo.19, Palani Andavar Temple 2nd Cross Street.. Ayanavaram, Ayanavaram, Anna Nagar, Chennai-600023	\N	\N	\N	\N	\N	\N	active	7	27	SHOOT ASSIST	1	2	2025-06-13 15:43:29.026+05:30	2025-06-13 15:43:29.026+05:30	\N	\N	\N	\N	\N	t
39	EMP-25-0035	NIKILKUMAR	M	nikilkimgzzz@gmail.com	8124887577	1, GROUND FLOOR, E - BLOCK, POLICE QUARTERS, TALUK OFFICE ROAD, HOSUR - 635109\r\nSri Sukkraa Cabs,No 6.BBC Manor, Duraisamay road, T nagar  Chennai   \r\n	\N	\N	\N	\N	\N	\N	active	7	27	SHOOT ASSIST	1	2	2025-06-13 15:44:41.82+05:30	2025-06-13 15:44:41.82+05:30	\N	\N	\N	\N	\N	t
40	EMP-25-0036	AJIN 	ACHANKUNJU	AJINPTCOO7@GMAIL.COM	9656403564	AJEESH NIVAS, ERAVICHIRA EAST, SOORANAD SOUTH, KOLLAM, KERALA - 690522	\N	\N	\N	\N	\N	\N	active	18	37	CANDID PHOTOGRAPHER	1	2	2025-06-13 15:45:39.847+05:30	2025-06-13 15:45:39.847+05:30	\N	\N	\N	\N	\N	t
41	EMP-25-0037	NITHYA YOGESWARI	R	NITHYARAVI1112@GMAIL.COM	6374282963	398, JOHN KENNADY STREET, ANNAI SATHYA NAGAR, JAFFERKHANPET, ASHOK NAGAR, CHENNAI - 600083	\N	\N	\N	\N	\N	\N	active	6	25	VIDEO EDITOR	1	2	2025-06-13 15:46:48.825+05:30	2025-06-13 15:46:48.825+05:30	\N	\N	\N	\N	\N	t
42	EMP-25-0038	SHEELI	J	SHEELI.JANARATHANAN@GMAIL.COM	9345216226	85/37, LOCO SCHEME 2ND STREET, JAWAHAR NAGAR, CHENNAI - 600082	\N	\N	\N	\N	\N	\N	active	1	1	SALES MANAGER	1	2	2025-06-13 15:49:00.645+05:30	2025-06-13 15:49:00.645+05:30	\N	\N	\N	\N	\N	t
44	EMP-25-0040	MAHALAKSHMI	S	SMAHA93@GMAIL.COM	9566191909	SF1, PREMIER NEST, 6/17, DHANASEKARAN CROSS STREET, WEST MAMABALAM, CHENNAI - 600033	\N	\N	\N	\N	\N	\N	active	4	33	ACCOUNTS ASSISTANT	1	2	2025-06-13 15:51:41.55+05:30	2025-06-13 15:51:41.55+05:30	\N	\N	\N	\N	\N	t
45	EMP-25-0041	ARUN	S	arunkavi060599@gmail.com	6374855958	\N	\N	\N	\N	\N	\N	\N	active	8	18	CINEMATOGRAPHER	1	2	2025-06-13 15:53:18.548+05:30	2025-06-13 15:53:18.548+05:30	\N	\N	\N	\N	\N	t
46	EMP-25-0042	HARISH	A	harish.arjunan95@gmail.lcom	8939355279	NO: 102, DURGAI AMMAN KOIL STREET, SOTHIYAMPAKKAM, TIRUVANAMALAI DIST. 631702 (OWN HOUSE)\r\nNO: 16, BAJANAI KOIL STREET, GANDHI ROAD, WEST TAMBARAM, CHENNAI, 600045 (RENTAL HOUSE)	\N	\N	\N	\N	\N	\N	active	1	1	SALES MANAGER	5	4	2025-06-13 16:02:46.696+05:30	2025-06-13 16:02:46.696+05:30	\N	\N	\N	\N	\N	t
48	EMP-25-0044	HEMA KUMAR	P	MAGICBLACK664@GMAIL.COM	7358107353	24/47, NEHRU NAGAR, VILLIVAKKAM, CHENNAI - 600 049\r\n	\N	\N	\N	\N	\N	\N	active	6	16	POST PRODUCTION MANAGER	1	2	2025-06-13 16:07:16.892+05:30	2025-06-13 16:07:16.892+05:30	\N	\N	\N	\N	\N	t
49	EMP-25-0045	SANTHOSH	S	U1PHOTOGRAPHY484@GMAIL.COM	9944673735	3, KALIYAPPA GOUNDER STREET, KUNIYAMUTHUR, COIMBATORE - 641008	\N	\N	\N	\N	\N	\N	active	6	15	VIDEO EDITOR	2	3	2025-06-13 16:09:03.929+05:30	2025-06-13 16:09:03.929+05:30	\N	\N	\N	\N	\N	t
31	EMP-25-0027	DHANASEKAR	J	jdhanasekar1973@gmail.com	9842201295	\N	\N	\N	\N	\N	\N	\N	active	1	3	SALES HEAD	1	2	2025-06-13 15:30:46.413+05:30	2025-06-13 15:30:46.413+05:30	\N	\N	$2b$12$5duiA0aLzbaRtsvXnXTB6ey/P08k2PHe9VtbZBEWCRjJKdf10w54a	\N	\N	t
43	EMP-25-0039	KISHORE	S	KISHORESARANGAN2@GMAIL.COM	9952943774	35B, SELVI HOMES, KALLIKUPPAM, THENDARL NAGAR 3RD STREET, AMABATTUR, CHENNAI - 600053	\N	\N	\N	\N	\N	\N	active	1	2	SALES EXECUTIVE	1	2	2025-06-13 15:50:18.901+05:30	2025-06-13 15:50:18.901+05:30	\N	\N	$2b$12$5duiA0aLzbaRtsvXnXTB6ey/P08k2PHe9VtbZBEWCRjJKdf10w54a	\N	\N	t
1	EMP-25-0001	Vikas	Alagarsamy	vikas@ooak.photography	09677362524	15/34, Thirumangalam Road, Navalar Nagar, Anna Nagar West,	Chennai	Tamil Nadu	600040	India	\N	\N	active	2	4	System Administrator	1	2	2025-06-11 16:49:38.372+05:30	2025-06-18 23:00:31.186+05:30	Admin User	admin	$2b$12$5duiA0aLzbaRtsvXnXTB6ey/P08k2PHe9VtbZBEWCRjJKdf10w54a	1	2025-06-18 06:45:08.675	t
47	EMP-25-0043	SAINATH 	REDDY	gadesainathreddy@gmail.com	9989113039	6-4-144 Saibaba nagar, Aramghar, Rajendra Nagar,  Hyderabad500077	\N	\N	\N	\N	\N	\N	active	1	1	BRANCH MANAGER	4	2	2025-06-13 16:04:36.954+05:30	2025-06-24 06:49:59.180648+05:30	\N	\N	\N	\N	\N	t
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.events (id, event_id, name, is_active, created_at, updated_at) FROM stdin;
119024ad-a757-4861-988a-c31ebdece661	EJRWTPY55	Wedding	t	2025-06-13 09:16:47.609+05:30	2025-06-13 09:16:47.609+05:30
a644169c-7529-4624-8429-87eee409ed81	EB29D4F2J	Reception	t	2025-06-13 09:16:52.878+05:30	2025-06-13 09:16:52.878+05:30
b0de270e-9759-4467-8792-4dbf350f14a4	EC9VQVU3J	Mehandi	t	2025-06-13 09:16:56.973+05:30	2025-06-13 09:16:56.973+05:30
34af26bd-7d02-4ad3-a472-5396b3b2d86a	ENMA65VFB	Sangeet	t	2025-06-13 09:17:00.406+05:30	2025-06-13 09:17:00.406+05:30
62015a59-13c5-4a4a-9a98-fff578c5efa1	EXDAYTCX3	Engagement	t	2025-06-13 16:49:47.403+05:30	2025-06-13 16:49:47.403+05:30
fe567b23-b223-4d51-8792-a42bf8612832	EV6TKZXAN	Sami Valipadu	t	2025-06-13 16:57:48.56+05:30	2025-06-13 16:57:48.56+05:30
a3299970-d0a9-4660-b325-8cc3385b7391	ELWUFJ4JF	Bharaat	t	2025-06-13 16:57:56.259+05:30	2025-06-13 16:57:56.259+05:30
3aa43f0f-d33a-4f0c-b3e8-4422722b91a5	EJZAY8DST	Bridal Function	t	2025-06-13 16:58:13.577+05:30	2025-06-13 16:58:13.577+05:30
353c24d9-b194-4c55-8818-871a6666524e	E3DNEGSSR	Cocktail Party	t	2025-06-13 16:58:20.577+05:30	2025-06-13 16:58:20.577+05:30
b34e27fe-c5e0-40e1-871f-24344be58c0a	E7FPC5K49	Haldi\t	t	2025-06-13 17:02:32.171+05:30	2025-06-13 17:02:32.171+05:30
f3cb13f6-e5af-4449-8b44-a53164085dbd	ESXGCQAQ3	Get together	t	2025-06-14 12:38:23.94+05:30	2025-06-14 12:38:23.94+05:30
775ae420-2eed-4cc7-9cb9-f8b76df0ff3f	EW7SVTHDJ	Lagnapatrika	t	2025-06-14 12:38:34.376+05:30	2025-06-14 12:38:34.376+05:30
3951d101-77a4-42b9-8e29-d7d50175df4e	E9BTN77S8	Mangalasnanam	t	2025-06-14 12:38:40.934+05:30	2025-06-14 12:38:40.934+05:30
7a43395e-c48f-4dc6-8245-ccf774869c8f	E3TBSSWER	Mehandi/Sangeet	t	2025-06-14 12:38:50.04+05:30	2025-06-14 12:38:50.04+05:30
8971b7a2-1ba0-4703-9671-74521e245bcd	ESRLRW6MY	Nalangu	t	2025-06-14 12:38:54.942+05:30	2025-06-14 12:38:54.942+05:30
f8f80dc5-7367-4be1-9541-47dd4b7e040b	ETWBERHT4	Odugu	t	2025-06-14 12:38:59.811+05:30	2025-06-14 12:38:59.811+05:30
55c949d1-1a3e-4b4c-914d-6715c17cb973	ED5SVRXAM	Outdoor photoshoot\t	t	2025-06-14 12:39:10.024+05:30	2025-06-14 12:39:10.024+05:30
ae2d39ba-4de1-4bf7-876a-818506d55b12	EHV3DAH9D	Outdoor Videoshoot	t	2025-06-14 12:39:15.724+05:30	2025-06-14 12:39:15.724+05:30
07284396-11b0-4b2d-8db9-68e3b369935b	E5WNKU5F9	Patni Seer\t	t	2025-06-14 12:39:20.219+05:30	2025-06-14 12:39:20.219+05:30
e8b06c41-ed30-46bd-8515-e93f0890504f	EK695Y8PR	Pellikuthuru/Mangalasnanam	t	2025-06-14 12:39:28.361+05:30	2025-06-14 12:39:28.361+05:30
35c9d50e-0a78-4147-a175-52b99ba2d6c6	EVHGN7T8E	Reception 2	t	2025-06-14 12:39:42.631+05:30	2025-06-14 12:39:42.631+05:30
fb9eaac4-ff39-4fa0-b1ba-a27112d61af9	E3VUGZL4N	Traditional Event	t	2025-06-14 12:39:51.521+05:30	2025-06-14 12:39:51.521+05:30
7c3e4162-81eb-43c7-924b-8d547833fe98	EDKEB7QKN	10th Anniversary	t	2025-06-14 12:40:24.675+05:30	2025-06-14 12:40:24.675+05:30
969111e2-698a-4773-af5c-19bbef19d738	E5WSSCD95	1st Birthday function	t	2025-06-14 12:40:31.877+05:30	2025-06-14 12:40:31.877+05:30
39cd105b-dc38-4f2d-969b-b701458baa8c	EAXAW6VZQ	25th Wedding Anniversary	t	2025-06-14 12:40:36.662+05:30	2025-06-14 12:40:36.662+05:30
f3927c96-ab2f-4c57-a08a-86b012566c2e	ESWNN7388	60th Birthday	t	2025-06-14 12:40:45.168+05:30	2025-06-14 12:40:45.168+05:30
f9cd89c8-9537-40ce-b55f-a07e845751c1	ESRLX4ZT9	Ad Shoot	t	2025-06-14 12:41:43.766+05:30	2025-06-14 12:41:43.766+05:30
b8c8cff9-9b69-490d-bbc4-1466d19e00d7	EU5KTJ2MJ	Ayusha Homam	t	2025-06-14 12:41:54.977+05:30	2025-06-14 12:41:54.977+05:30
13bd768a-bdb6-40d0-88b3-55c366746ce4	ERJ8FHRHF	Baby Baptism	t	2025-06-14 12:42:00.833+05:30	2025-06-14 12:42:00.833+05:30
4d8940e7-4d16-470b-a6de-c9404f63ad1e	EN8FKKVEC	Baby Cradle Ceremony	t	2025-06-14 12:42:08.133+05:30	2025-06-14 12:42:08.133+05:30
ce6b5ae5-2569-4bf7-8b1e-88da84ebe01b	E9UXMMDHG	Baby Event\t	t	2025-06-14 12:42:20.531+05:30	2025-06-14 12:42:20.531+05:30
9c6559bc-5278-4a75-b740-a169a7fd7afc	EQS67AH2T	Baby Shoot Indoor\t	t	2025-06-14 12:42:27.657+05:30	2025-06-14 12:42:27.657+05:30
4fbf184b-a33c-472d-95bf-ae72bef44e3b	E3P8BKGBL	Baby Shoot Outdoor\t	t	2025-06-14 12:42:32.289+05:30	2025-06-14 12:42:32.289+05:30
7b4332ae-d8df-4aae-9bcf-eb428c646784	E43U9X4TY	Baby Shower\t	t	2025-06-14 12:42:37.159+05:30	2025-06-14 12:42:37.159+05:30
682de4e0-e863-4b19-9199-5f28beb89fdc	EV9M6ZRSG	Bachelor's Party	t	2025-06-14 12:42:45.05+05:30	2025-06-14 12:42:45.05+05:30
684a2363-6e8f-4ad3-bda1-922166fa3a0c	EZSSHDM92	Bangle Function\t	t	2025-06-14 12:42:51.98+05:30	2025-06-14 12:42:51.98+05:30
5f0d2c68-9b19-4d96-9627-7a61679ccf34	ECU4VSU23	Baraat and Wedding	t	2025-06-14 12:43:03.962+05:30	2025-06-14 12:43:03.962+05:30
ee306c17-af3f-4e0e-a2b8-22ac557a888c	E29WEWJ3W	Batisi	t	2025-06-14 12:43:25.762+05:30	2025-06-14 12:43:25.762+05:30
9d118393-1d42-49de-8662-3d4d7e42c5c4	EWPZCYQJ3	Bengali Wedding	t	2025-06-14 12:43:32.843+05:30	2025-06-14 12:43:32.843+05:30
5ef52a6d-0208-4110-8209-3770574f2232	ELXZFC7PY	Bhaat	t	2025-06-14 12:43:40.466+05:30	2025-06-14 12:43:40.466+05:30
595809f1-6ff8-43b8-8241-7de74ede1a0c	E7F846SW7	Bhajan\t	t	2025-06-14 12:43:46.06+05:30	2025-06-14 12:43:46.06+05:30
3279683e-d05d-475b-903b-96b69b0de4c2	ERRYLA354	Bharaat, Sangeet, Dinner	t	2025-06-14 12:43:59.038+05:30	2025-06-14 12:43:59.038+05:30
0c335bea-e0ac-41fe-830d-39c59084389a	EHA6XHKFE	Bharaat, Varmala, Phera, Reception	f	2025-06-14 12:43:12.023+05:30	2025-06-14 12:44:23.544+05:30
9f06adbc-9807-4853-8536-3563ebbb93f4	EN6ZHZWMQ	Bharaat, Varmala, Phera	t	2025-06-14 12:44:38.413+05:30	2025-06-14 12:44:38.413+05:30
24693c37-de5e-405c-b268-9a51008fab80	EU5EVP4D3	Bidaai	t	2025-06-14 12:44:43.365+05:30	2025-06-14 12:44:43.365+05:30
fca9fcaf-11d6-45f0-9d62-7f052e5f7d3e	ELXFRWZNM	Birthday	t	2025-06-14 12:44:52.153+05:30	2025-06-14 12:44:52.153+05:30
2c3a7ed8-8b95-4964-b0f1-512a7a7d65d9	EGJZ7R9TY	Brahmin Wedding	t	2025-06-14 12:44:58.024+05:30	2025-06-14 12:44:58.024+05:30
0ef7a6b0-907f-4808-bb34-6ca395dd2bf0	EEMMWY478	Brahmin Wedding (Tamil)	t	2025-06-14 12:45:05.813+05:30	2025-06-14 12:45:05.813+05:30
e26ccc4e-813a-497c-9b08-69db884c4a2c	EQ4BJMJA8	Brahmin Wedding (Telugu)	t	2025-06-14 12:45:10.643+05:30	2025-06-14 12:45:10.643+05:30
8a920844-f1b9-4ae0-af78-fabd5bb065ed	E44R25GHH	Branding Shoot	t	2025-06-14 12:45:16.784+05:30	2025-06-14 12:45:16.784+05:30
beed5d69-bfe8-422d-8afc-f39b44177d01	E7NP8J7S7	Branding Work	t	2025-06-14 12:45:25.018+05:30	2025-06-14 12:45:25.018+05:30
85a14630-030b-4f5f-9055-3eb251077caa	E8YG25SYU	Bridal Shower\t	t	2025-06-14 12:45:35.806+05:30	2025-06-14 12:45:35.806+05:30
176fdef2-1c90-438b-961d-f84b8f2a2432	EP6WWDFJF	Bride Entry\t	t	2025-06-14 12:45:43.897+05:30	2025-06-14 12:45:43.897+05:30
adc767e1-2f8e-4e41-b2fd-ff712cdfb1a5	EFY2XSXLG	Bride Groom Entry	t	2025-06-14 12:45:53.144+05:30	2025-06-14 12:45:53.144+05:30
2862051b-8c91-4c5a-9dcb-df40f6fcded4	E4SU5E2WE	Groom Entry	t	2025-06-14 12:46:01.221+05:30	2025-06-14 12:46:01.221+05:30
505fbc53-4626-4f7d-902f-0f639d617d74	EGYNBNVLF	Bride Groom Ceremony\t	t	2025-06-14 12:46:06.159+05:30	2025-06-14 12:46:06.159+05:30
f3978806-3492-43e2-a777-9d361d56e3fd	EZ996CUX6	Bride Pandhakaal\t	t	2025-06-14 12:46:11.072+05:30	2025-06-14 12:46:11.072+05:30
17a8cc89-7efd-4b81-aa22-ee12adbaa579	EVPM5HYPU	Bride Side Blessing\t	t	2025-06-14 12:46:16.992+05:30	2025-06-14 12:46:16.992+05:30
0baf52ad-05cc-4e84-a17b-c462071c198e	ERCK5HVEY	Bride Side Haldi\t	t	2025-06-14 12:46:20.976+05:30	2025-06-14 12:46:20.976+05:30
caa23fe8-c59a-4d72-a1dd-f2444d157964	EJYE9QXV6	Bride Side Mehendi\t	t	2025-06-14 12:46:31.861+05:30	2025-06-14 12:46:31.861+05:30
522d1989-9bdd-4487-bd11-4ae5b256a638	EWJ38MD85	Bride Side Rituals\t	t	2025-06-14 12:46:36.598+05:30	2025-06-14 12:46:36.598+05:30
aa6c1967-0c7c-4372-972a-cbb52a8bcc04	EVP4P7JM3	Bride Side Sangeet\t	t	2025-06-14 12:46:41.705+05:30	2025-06-14 12:46:41.705+05:30
00a914b6-5d24-41b0-a8a7-ededdd4bc47a	EKDNG27GG	Bride's Pooja\t	t	2025-06-14 12:46:46.339+05:30	2025-06-14 12:46:46.339+05:30
e597b157-d260-44e3-a408-e2db0adc5e4d	EFDW6EU5J	Bride's Roce\t	t	2025-06-14 12:47:00.116+05:30	2025-06-14 12:47:00.116+05:30
af76b0d1-33f8-473b-9364-10905f4d797d	EUH5NX5BS	Cake Cutting and Get Together\t	t	2025-06-14 12:47:07.345+05:30	2025-06-14 12:47:07.345+05:30
6e4de615-29fe-4619-82e7-bb91167e3eb7	ECKAPAWBL	Carnival	t	2025-06-14 12:47:14.567+05:30	2025-06-14 12:47:14.567+05:30
42580653-1177-4db8-973d-128635d31ed7	E95WXVS4Z	Carnival & Haldi\t	t	2025-06-14 12:47:19.618+05:30	2025-06-14 12:47:19.618+05:30
d740cc48-7c1d-4c81-b05e-f64427fd212b	EJH342598	Christian Wedding\t	t	2025-06-14 12:47:23.519+05:30	2025-06-14 12:47:23.519+05:30
35433a1c-c453-46a8-9727-34e5e50e0d62	EFYMY5CXP	Cocktail / Reception\t	t	2025-06-14 12:47:28.043+05:30	2025-06-14 12:47:28.043+05:30
8610db0b-a22f-4366-b93d-b51626cb044b	E5T2MQJA4	Cocktail Party 2\t	t	2025-06-14 12:47:37.029+05:30	2025-06-14 12:47:37.029+05:30
c1c06682-1118-41a5-9f17-9fe0d56618e7	ENDY5TY9B	Commercial shoot\t	t	2025-06-14 12:47:41.27+05:30	2025-06-14 12:47:41.27+05:30
6112efbe-1a9b-4413-b7fc-f624609343d6	ENZNH9EA8	Concert Event	t	2025-06-14 12:48:44.983+05:30	2025-06-14 12:48:44.983+05:30
d285eef3-7e2e-4160-91ae-a50a26092672	EHQSGBZJF	Corporate Shoot	t	2025-06-14 12:48:55.034+05:30	2025-06-14 12:48:55.034+05:30
a4752287-599e-48c3-9074-e71dba232be3	EVAHUN9RT	Court Wedding	t	2025-06-14 12:49:01.871+05:30	2025-06-14 12:49:01.871+05:30
a53993b8-7888-457d-811d-75118f204a63	E9NVD5XN5	Decor Coverage	t	2025-06-14 12:49:07.42+05:30	2025-06-14 12:49:07.42+05:30
2522de78-92bf-4836-8521-6c64960d1ad4	EQDPBJ34T	Decor Photography & Videography\t	t	2025-06-14 12:49:23.823+05:30	2025-06-14 12:49:23.823+05:30
100c36b6-3357-456f-88af-4c6f5ded3f01	EGB6BSXDG	Dhothi Ceremony\t	t	2025-06-14 12:49:29.948+05:30	2025-06-14 12:49:29.948+05:30
940a40af-a08d-4de5-a3dd-d37ee4c316c9	EW9JUGVNG	Digital Marketing	t	2025-06-14 12:49:36.263+05:30	2025-06-14 12:49:36.263+05:30
6404140d-f1ca-4cb0-921e-4e5284218b30	EPJM4DJEH	Dinner Party\t	t	2025-06-14 12:49:48.082+05:30	2025-06-14 12:49:48.082+05:30
775121ca-ff2d-46f0-bd9f-8aa1eb7d0dd2	E3YABRJL2	Dinner/Sangeet\t	t	2025-06-14 12:49:53.974+05:30	2025-06-14 12:49:53.974+05:30
d9cd70a2-3813-4dfc-8677-cd73afc1b608	EJA4KYF7X	Ear Piercing\t	t	2025-06-14 12:49:58.98+05:30	2025-06-14 12:49:58.98+05:30
6cb4b3d0-999b-40c7-ae66-39c876c29159	EUNHRY3MM	Edurukolu	t	2025-06-14 12:50:07.773+05:30	2025-06-14 12:50:07.773+05:30
2225ceb2-45c9-484e-a85b-b51618b231c5	EZPD9GY73	Engagement & Sangeet\t	t	2025-06-14 12:50:16.024+05:30	2025-06-14 12:50:16.024+05:30
f29a9932-ad26-4323-b075-80c3616c0aa4	E7VZEV8T7	Engagement & Seeru\t	t	2025-06-14 12:50:20.406+05:30	2025-06-14 12:50:20.406+05:30
5be6672e-597e-4763-aafe-6e0aba767cac	ESJ3RUBS2	Engagement / Asheervaad\t	t	2025-06-14 12:50:28.69+05:30	2025-06-14 12:50:28.69+05:30
7f027a74-c022-4cb1-8dcd-d92cabe87829	E6GW2SNHN	Engagement or Betrothal or Nichayathartham\t	t	2025-06-14 12:50:37.369+05:30	2025-06-14 12:50:37.369+05:30
c3d6d30d-a30d-4d30-be83-48f45dfb310e	E4RY5TUSC	Engagement/Haldi\t	t	2025-06-14 12:50:42.533+05:30	2025-06-14 12:50:42.533+05:30
231978a0-e154-4525-8d05-1f8461060ea3	E6597CG9G	Post Wedding shoot	f	2025-06-14 12:39:34.341+05:30	2025-06-14 13:42:00.503+05:30
1855cd86-a1a6-4b91-b5c0-c2e2a3b14a59	E29XT87G7	Engagement/Reception\t	t	2025-06-14 12:50:47.27+05:30	2025-06-14 12:50:47.27+05:30
db871a16-e1af-4258-bba1-e66984517ded	EPYC7ZW6S	Engagement/Sangeet\t	t	2025-06-14 12:50:52.081+05:30	2025-06-14 12:50:52.081+05:30
c4255427-2d03-4835-a59e-a05d22a74d89	EFBUM9DJN	Event Coverage\t	t	2025-06-14 12:51:02.171+05:30	2025-06-14 12:51:02.171+05:30
8008f214-6bed-48ed-8b95-5127fa8e6d82	EE2KBRTYA	Family Get together	t	2025-06-14 13:24:55.883+05:30	2025-06-14 13:24:55.883+05:30
78dc2fe2-ab0f-4932-9770-83200b6a3583	ET4B79LQQ	Family Rituals	t	2025-06-14 13:25:02.45+05:30	2025-06-14 13:25:02.45+05:30
9a5361ba-2b65-4937-8a86-f58090597b07	EA9J6DXYP	Fashion Shoot	t	2025-06-14 13:25:14.004+05:30	2025-06-14 13:25:14.004+05:30
8245edd1-b9d1-4c23-a91d-9cbf99cbb6de	EFM8CWVD9	Ganapathy Pooja	t	2025-06-14 13:25:37.501+05:30	2025-06-14 13:25:37.501+05:30
7fc7f15c-4e43-4684-81d1-21330da4da2c	E6AF8C8YN	Ganesh Sthapana, Mata Ji poojan & Mehendi\t	t	2025-06-14 13:25:45.036+05:30	2025-06-14 13:25:45.036+05:30
6f2675de-2e22-47ca-a6c6-d301971a061f	E365NBJV3	Ghee Pilai\t	t	2025-06-14 13:29:52.795+05:30	2025-06-14 13:29:52.795+05:30
09a2d645-60ec-4117-ad0d-dd4d5cb68fa4	EQS4ZHLCK	Gowri Pooja & Kashi Yatra\t	t	2025-06-14 13:30:02.672+05:30	2025-06-14 13:30:02.672+05:30
98c0ea4b-7382-483e-aec7-134eea8c51fd	EWQC8V2C7	Groom Entry\t	t	2025-06-14 13:30:08.328+05:30	2025-06-14 13:30:08.328+05:30
67835fbf-d3cd-4655-94fc-75713e3794a6	E2BM2DWUJ	Groom Pandhakaal\t	t	2025-06-14 13:30:14.702+05:30	2025-06-14 13:30:14.702+05:30
5353f355-c50a-47eb-b83b-1a0bc404fa5c	EVHUFEC6L	Groom Side Blessing\t	t	2025-06-14 13:30:20.987+05:30	2025-06-14 13:30:20.987+05:30
84744f0c-d0e2-471e-9461-aa570ad9ea20	ER9EG9FKW	Groom Side Haldi\t	t	2025-06-14 13:30:26.549+05:30	2025-06-14 13:30:26.549+05:30
0d316afb-bef8-4ac4-831e-0aa79a4311c6	EL87MAELP	Groom Side Mehendi\t	t	2025-06-14 13:30:37.998+05:30	2025-06-14 13:30:37.998+05:30
b9baabee-ddb0-4d4f-aabd-a651d7284078	EFPMXNM9A	Groom Side Reception\t	t	2025-06-14 13:30:42.415+05:30	2025-06-14 13:30:42.415+05:30
52766119-51b2-4ab6-8270-38185414b703	ELSVN4AW2	Groom Side Rituals\t	t	2025-06-14 13:30:46.874+05:30	2025-06-14 13:30:46.874+05:30
71eb924f-6914-4fd2-806e-f6709203e98c	EN9JV8826	Groom Side Sangeet\t	t	2025-06-14 13:30:51.492+05:30	2025-06-14 13:30:51.492+05:30
51f413f4-edbb-499c-95fa-e1575ffc7c59	EK6FARLTF	Groom Welcoming\t	t	2025-06-14 13:30:57.587+05:30	2025-06-14 13:30:57.587+05:30
e3f6c555-679a-4b1c-9c86-38a74e18ee1d	EVJ76GQHM	Groom's Roce\t	t	2025-06-14 13:31:02.653+05:30	2025-06-14 13:31:02.653+05:30
c8ec22b6-c866-48a5-b510-fc988a76c9f2	E6YRE3VPW	Guru Pooja\t	t	2025-06-14 13:31:06.425+05:30	2025-06-14 13:31:06.425+05:30
ffd4a69b-a20e-480b-9440-282b7a5f7980	EASKPK4F8	Haldi & Pellikodukku\t	t	2025-06-14 13:31:13.017+05:30	2025-06-14 13:31:13.017+05:30
3e22179a-ea21-4360-9292-161dbda28d45	EVTXT8DEL	Haldi 2\t	t	2025-06-14 13:31:18.759+05:30	2025-06-14 13:31:18.759+05:30
23359bd9-e186-4743-bb8f-37bb39d1e5cb	EZVVUDP84	Haldi/Engagement\t	t	2025-06-14 13:31:23.3+05:30	2025-06-14 13:31:23.3+05:30
d0ad4339-87cb-4174-bece-ddafef4c6125	E43AZL27V	Haldi/Mehandi\t	t	2025-06-14 13:31:28.346+05:30	2025-06-14 13:31:28.346+05:30
6f96f625-9f1c-478a-900e-cd1d09a02b8a	E7WQ8LCM2	Haldi/Pellikuthuru\t	t	2025-06-14 13:31:54.616+05:30	2025-06-14 13:31:54.616+05:30
0e419bac-d49a-45da-ad50-497be16ee679	E9JRFS9YX	Haldi/Sangeet\t	t	2025-06-14 13:32:09.74+05:30	2025-06-14 13:32:09.74+05:30
689b9fcf-d0a9-4f9c-9e77-8e840b0eaac1	EF8453HM3	Half Saree Function\t	t	2025-06-14 13:32:17.11+05:30	2025-06-14 13:32:17.11+05:30
4bb1d84e-b88a-4e77-8e34-4da4c618f1cd	EEUBKMU2X	High Tea\t	t	2025-06-14 13:32:27.128+05:30	2025-06-14 13:32:27.128+05:30
c14f0f7b-c84e-4454-ae7b-9b3b49b49af6	ENECQUZ6U	Hindu Wedding\t	t	2025-06-14 13:32:34.439+05:30	2025-06-14 13:32:34.439+05:30
7ae433a1-ccbc-470c-b9ce-2a53fd0f1c7c	EYY447N22	Homam	t	2025-06-14 13:32:41.131+05:30	2025-06-14 13:32:41.131+05:30
900a114c-c550-48a0-8f13-612fe98923c3	EYXPBRHLL	House Entering Ceremony\t	t	2025-06-14 13:32:46.623+05:30	2025-06-14 13:32:46.623+05:30
33edbf3d-d6e9-463d-8d91-5aa2e2a4eef4	EKWATK22L	House Warming\t	t	2025-06-14 13:32:52.778+05:30	2025-06-14 13:32:52.778+05:30
35e5d086-e94b-434d-bf81-5dafc719ea8e	EL7NGRDGZ	Janavasam\t	t	2025-06-14 13:33:20.279+05:30	2025-06-14 13:33:20.279+05:30
7dfe0789-392e-42e4-a6c0-37596ad27eb3	EUR5ES7FW	Kasi Yathirai\t	t	2025-06-14 13:33:29.148+05:30	2025-06-14 13:33:29.148+05:30
98ffef8a-f9d8-433b-b932-ec10e0adda8e	E3M9WZRUX	Kerala Wedding\t	t	2025-06-14 13:33:36.238+05:30	2025-06-14 13:33:36.238+05:30
4c1bf774-8358-417c-a5af-a534b1217ffa	E9GD94HQZ	Lagna Shastra\t	t	2025-06-14 13:33:43.267+05:30	2025-06-14 13:33:43.267+05:30
15b736f5-7324-4d9f-9baa-e181d5146e69	EDSKARYYG	Mangalasnanam\t	t	2025-06-14 13:34:04.38+05:30	2025-06-14 13:34:04.38+05:30
3377ef23-1f4b-4ef2-af64-a5f66ebf53f1	E88MX4Z5W	Mangalasnanam/Pellikoduku\t	t	2025-06-14 13:34:09.327+05:30	2025-06-14 13:34:09.327+05:30
b41a8494-034b-43cc-a95d-c3b6a50a475e	EF39TW8NM	Mapillai Azhaippu\t	t	2025-06-14 13:34:26.382+05:30	2025-06-14 13:34:26.382+05:30
ab40e8fd-f202-4e9f-996c-a358a9002d45	E8SJFKWZT	Mappillai Azhaipu & Reception\t	t	2025-06-14 13:34:33.337+05:30	2025-06-14 13:34:33.337+05:30
204190ca-e271-4d91-818f-3da25fb2e23c	EH3C3SBPN	Maruveedu	t	2025-06-14 13:34:38.196+05:30	2025-06-14 13:34:38.196+05:30
a7117c1a-1293-439b-b562-e5990d41371c	EJXB4M4ZP	Maternity Shoot\t	t	2025-06-14 13:34:45.992+05:30	2025-06-14 13:34:45.992+05:30
23702dd6-065a-4c5a-b317-d9666ac96987	EXAJRELA3	Mayara	t	2025-06-14 13:34:52.793+05:30	2025-06-14 13:34:52.793+05:30
5712c30e-064a-46ec-9b5d-7fcfdacef96d	EYN66S86Y	Mehandi/Cocktail\t	t	2025-06-14 13:35:01.612+05:30	2025-06-14 13:35:01.612+05:30
b5d04237-789b-4cf0-a8e0-5e76c226c109	EKPFC4WRJ	Mehandi/Sundowner/Formal Dinner\t	t	2025-06-14 13:35:06.886+05:30	2025-06-14 13:35:06.886+05:30
78b66d10-6a73-42b0-8f71-e7a73b3bb7ac	E4N6MNXGA	Mehendi/Sangeet\t	t	2025-06-14 13:35:14.003+05:30	2025-06-14 13:35:14.003+05:30
51a163a5-3d82-45d5-93a3-20552b2c8542	E9WF3N8Z9	Moong Bikhrai\t	t	2025-06-14 13:35:41.745+05:30	2025-06-14 13:35:41.745+05:30
ed59295e-afd9-44d6-8766-4b87eb13a111	E6RJQ386P	Mottai & Kathukuthu\t	t	2025-06-14 13:35:49.243+05:30	2025-06-14 13:35:49.243+05:30
be86c4f4-2525-4fff-bbb6-fef133d40c9d	E5SCF6KDS	Muhurtham\t	t	2025-06-14 13:35:54.134+05:30	2025-06-14 13:35:54.134+05:30
5c979d95-3a80-4e44-a572-9d6578ff62c7	EU5CECFNQ	Nagavalli	t	2025-06-14 13:36:02.22+05:30	2025-06-14 13:36:02.22+05:30
8c7cc172-0595-4b76-a889-aa55825d4d58	EQ3ZHV648	Musical Night\t	t	2025-06-14 13:36:07.781+05:30	2025-06-14 13:36:07.781+05:30
87e74a3b-f148-4b2b-a9c1-06a5bc9f19e9	E6AGA5ZBB	Nalangu & Vilayaadal\t	t	2025-06-14 13:36:13.462+05:30	2025-06-14 13:36:13.462+05:30
5266603e-3715-4ace-87d3-b2e69f04b5fd	EZZMUL2G8	Nalangu Bride Side\t	t	2025-06-14 13:36:22.4+05:30	2025-06-14 13:36:22.4+05:30
20f0ccee-5b23-46e9-845a-0195006ca338	EUQ4UYKPY	Nalangu Groom Side\t	t	2025-06-14 13:36:28.948+05:30	2025-06-14 13:36:28.948+05:30
4eb18c6b-40fd-440c-b846-a85478088c05	ESHWHHUUU	Naming Ceremony\t	t	2025-06-14 13:36:33.87+05:30	2025-06-14 13:36:33.87+05:30
f65458ec-fb10-4d55-a795-a9983d049e38	EK2MGHL53	Nichayathartham\t	t	2025-06-14 13:36:45.711+05:30	2025-06-14 13:36:45.711+05:30
e5ba0b8e-2606-4f0e-bd82-ef4d83eaf8ea	EA4HM3BNR	Nichayathartham & Reception\t	t	2025-06-14 13:36:50.198+05:30	2025-06-14 13:36:50.198+05:30
4b24c022-fc72-4fda-8c3d-7de43409d256	E3R33D597	Nikasi\t	t	2025-06-14 13:37:18.164+05:30	2025-06-14 13:37:18.164+05:30
27c2bc44-3ae5-41e8-ba18-bcd91d426f4b	E58Z7NCS5	Nikkah	t	2025-06-14 13:37:23.238+05:30	2025-06-14 13:37:23.238+05:30
45a21555-5b01-49f9-acd6-9ee00d4d75bf	EKJ8YKH7B	North Indian Wedding\t	t	2025-06-14 13:37:32.841+05:30	2025-06-14 13:37:32.841+05:30
f8acc462-612e-4237-accc-30304fa77568	EXZU2WY2C	Outdoor Shoot\t	t	2025-06-14 13:38:03.715+05:30	2025-06-14 13:38:03.715+05:30
c1f3dd1e-5809-4598-b666-a95ca0005ce9	EDZ7PRCTD	Paat Bithai & Mayra\t	t	2025-06-14 13:38:10.033+05:30	2025-06-14 13:38:10.033+05:30
a04f27a9-bf3e-4f38-9229-aff2197425ea	ESXGSMK85	Pandhakaal, Pellikodukku, Pellikuthuru\t	t	2025-06-14 13:38:18.768+05:30	2025-06-14 13:38:18.768+05:30
33a796cb-1ddf-4963-94aa-631d62ba91a6	ED6YTFQAP	Pandhakaal	t	2025-06-14 13:38:24.006+05:30	2025-06-14 13:38:24.006+05:30
aebfa599-46a4-44e3-a2b4-45f9ff1ab16c	ENA3GXVN8	Pandhakal & Nalangu\t	t	2025-06-14 13:38:29.456+05:30	2025-06-14 13:38:29.456+05:30
9bc1686e-c94d-4cfa-9252-be0f931ea43d	E58HTXF75	Parsi Wedding\t	t	2025-06-14 13:38:35.458+05:30	2025-06-14 13:38:35.458+05:30
34a6f593-dc2c-4edf-8ff4-4bd114a39081	ENBG5ARAX	Pasupu Kottadam (Bride Side)\t	t	2025-06-14 13:38:43.987+05:30	2025-06-14 13:38:43.987+05:30
2bc6caa6-311d-4839-8d10-92516715e2b0	ESURKMWWY	Pasupu Kottadam (Groom Side)\t	t	2025-06-14 13:38:49.754+05:30	2025-06-14 13:38:49.754+05:30
f8ec5975-bd07-44e7-811a-2f068eb14958	EG3UX7C9K	Pasupu or Pasupu Kottadam\t	t	2025-06-14 13:39:13.526+05:30	2025-06-14 13:39:13.526+05:30
6f49d768-2740-4973-87a2-657cfa56704b	EFLE84FMP	Pelikoduku - Sangeet - Engagement - Edurkolu\t	t	2025-06-14 13:39:36.428+05:30	2025-06-14 13:39:36.428+05:30
e8c71151-9714-47ad-9648-befb0ac12a33	EE9CZC9SQ	Pellikodukku	t	2025-06-14 13:39:50.899+05:30	2025-06-14 13:39:50.899+05:30
29e66339-c950-4571-9643-b5b4d6ded700	E5WT87JQZ	Pellikuthuru\t	t	2025-06-14 13:40:01.332+05:30	2025-06-14 13:40:01.332+05:30
d0f02319-7c94-4014-bb6d-e7b4c7dbbe56	EZMNW9D6H	Pellikuthuru/Groom Welcoming/Bride Welcoming\t	t	2025-06-14 13:40:43.496+05:30	2025-06-14 13:40:43.496+05:30
4f741176-fdf4-42cc-be46-8975f0515296	EVZCZQSDA	Penn Azhaippu / Mapillai Azhaippu / Engagement\t	t	2025-06-14 13:40:48.915+05:30	2025-06-14 13:40:48.915+05:30
7a44c96f-4824-43e6-8192-0c03b0f29671	EQNP4VTJ3	Penn Azhaipu\t	t	2025-06-14 13:40:55.74+05:30	2025-06-14 13:40:55.74+05:30
069348d3-c747-4c67-9e99-fac0d9f0466a	EU2S344QF	Poochutum Vizha\t	t	2025-06-14 13:41:03.067+05:30	2025-06-14 13:41:03.067+05:30
9a23fc91-6ff5-4066-bd6e-c280b867bdd1	EM8BDLGM7	Pooja & Tilak\t	t	2025-06-14 13:41:09.137+05:30	2025-06-14 13:41:09.137+05:30
d74301aa-5f54-4c10-8895-4740b89829f3	EB6CGQ9HE	Pooja	t	2025-06-14 13:41:12.3+05:30	2025-06-14 13:41:12.3+05:30
1f2b9cc9-d405-477e-a68c-95c5d00d1fba	EVKLBWDZQ	Pool Party\t	t	2025-06-14 13:41:19.363+05:30	2025-06-14 13:41:19.363+05:30
81d56b33-3bbc-4df7-b497-5f94ea9e636b	EHLE7GTGZ	Post Wedding Rituals\t	t	2025-06-14 13:41:25.641+05:30	2025-06-14 13:41:25.641+05:30
6dc2cba8-f355-4972-9168-7a38d77f5971	EV79TLB8T	Pradhanam	t	2025-06-14 13:42:10.564+05:30	2025-06-14 13:42:10.564+05:30
81686188-74c5-4d32-8460-f6bed2f988a2	EQB8RK9HQ	Prayer Meeting\t	t	2025-06-14 13:42:23.146+05:30	2025-06-14 13:42:23.146+05:30
e79cb6c7-77b1-4b08-8e80-0a69e73788d3	E9WH5ETQA	Pre Engagement	t	2025-06-14 13:42:30.012+05:30	2025-06-14 13:42:30.012+05:30
4e38b425-d325-437d-b99f-e51e3ef2b4c8	E9V798EVN	Pre Wedding Function (Bride)\t	t	2025-06-14 13:42:38.69+05:30	2025-06-14 13:42:38.69+05:30
ea3cfc53-1998-4de5-9b92-f9e890dd9f8c	E4Q69SZBC	Pre Wedding Function (Groom)\t	t	2025-06-14 13:42:45.139+05:30	2025-06-14 13:42:45.139+05:30
f3d2bccd-d27e-4725-b229-fdcddc9a7cdb	ED74PE2HS	Pre-Wedding Reception\t	t	2025-06-14 13:42:52.509+05:30	2025-06-14 13:42:52.509+05:30
6bfe515c-2605-4f11-b7b6-3445371a9244	EJMRVMMJ6	Product Shoot\t	t	2025-06-14 13:43:08.927+05:30	2025-06-14 13:43:08.927+05:30
27d007e1-2543-4e78-b0d9-2f3d06b4b7b9	EYWHKJJPX	Pre-Wedding Rituals\t	t	2025-06-14 13:43:01.591+05:30	2025-06-14 13:43:01.591+05:30
74903af8-7b08-411c-8d19-1d2be13c977a	ED8SQELAM	Puberty Function\t	t	2025-06-14 13:43:15.241+05:30	2025-06-14 13:43:15.241+05:30
de3128a3-3b4a-4a6e-9c2a-096ba8d2bb97	E8PG3RVEW	Punjabi Wedding\t	t	2025-06-14 13:43:21.376+05:30	2025-06-14 13:43:21.376+05:30
2de526de-835c-49cd-a946-fccdd8d10d7a	ENMNDGGKF	Raj Tilak & Mehandi\t	t	2025-06-14 13:43:28.203+05:30	2025-06-14 13:43:28.203+05:30
2cae66bd-e2f8-40fe-bbcc-c10a9f109273	EXWHQAZ2M	Reception/Wedding\t	t	2025-06-14 13:43:38.041+05:30	2025-06-14 13:43:38.041+05:30
d2a9c379-e7cd-4f30-b528-3a35beaa7b77	EDCD3SYMZ	Ring Ceremony\t	t	2025-06-14 13:43:48.556+05:30	2025-06-14 13:43:48.556+05:30
222d4344-5a0e-4fb7-8ccd-6bf61964a58c	ERDEQ6GKH	Rituals	t	2025-06-14 13:43:55.518+05:30	2025-06-14 13:43:55.518+05:30
322fcfde-9323-4e00-9995-2bd7800485ac	EQE7HQMRV	Rituals & Wedding\t	t	2025-06-14 13:44:10.626+05:30	2025-06-14 13:44:10.626+05:30
91c6bd4a-2c6f-4fb3-8ca3-8b5af31d460b	E8WV5JURW	Roka	t	2025-06-14 13:44:16.366+05:30	2025-06-14 13:44:16.366+05:30
775f54f2-5db1-47d2-b8b9-1b674c9d6b73	ELEYW4R9R	Sangeet/Cocktail\t	t	2025-06-14 13:44:31.092+05:30	2025-06-14 13:44:31.092+05:30
b801a21b-df2b-4445-92fa-e07e13837147	ERAW3WLQM	Sangeet/Mehandi\t	t	2025-06-14 13:44:35.754+05:30	2025-06-14 13:44:35.754+05:30
8a00d70e-ed89-4b7e-bfbf-9ce6fc0268c6	E836UEDM6	Saree & Dhothi Function\t	t	2025-06-14 13:44:41.079+05:30	2025-06-14 13:44:41.079+05:30
68aac77c-937e-44b0-9083-aa9f3af65c30	EG98P64AY	sashtiapthapoorthi\t	t	2025-06-14 13:44:50.966+05:30	2025-06-14 13:44:50.966+05:30
77f21344-1b80-42a3-a3f1-e5f7ec8f2d72	E2R2QJME3	Sathyanarayana Pooja (Bride side)\t	t	2025-06-14 13:44:57.704+05:30	2025-06-14 13:44:57.704+05:30
ef218349-ac40-47eb-a217-be8921daee8a	E6EWXGJLK	Sathyanarayana Pooja (Groom side)\t	t	2025-06-14 13:45:05.679+05:30	2025-06-14 13:45:05.679+05:30
b565f2c3-a95e-434c-b890-23dc1348e619	ESUYUY8QJ	Sauntiya Habba\t	t	2025-06-14 13:45:09.899+05:30	2025-06-14 13:45:09.899+05:30
36d75b44-58ba-4f07-9d3d-daeb8f84450e	ENW5F22ME	Seeru	t	2025-06-14 13:45:18.731+05:30	2025-06-14 13:45:18.731+05:30
c862f21c-bde2-4d40-a41d-55967c3ce5e6	E3HQ7PTW7	Special Event\t	t	2025-06-14 13:45:35.777+05:30	2025-06-14 13:45:35.777+05:30
d2d3bc09-85f3-4bcc-8c26-5cd533ff4195	EJKVYRAM8	Sumangali Pooja\t	t	2025-06-14 13:45:48.191+05:30	2025-06-14 13:45:48.191+05:30
0528ced7-51c6-4168-ae67-aff5d97de1d5	EYGVHZ58X	Sundowner	t	2025-06-14 13:45:52.314+05:30	2025-06-14 13:45:52.314+05:30
30f4cafd-b08b-4fdf-87b0-f3029606db0a	EE64XACQB	Tamil Iyer Wedding\t	t	2025-06-14 13:45:59.748+05:30	2025-06-14 13:45:59.748+05:30
5f1aabda-026e-42c9-8063-31cd14d55898	E82HUTZWX	Tamil Wedding\t	t	2025-06-14 13:46:11.682+05:30	2025-06-14 13:46:11.682+05:30
d088343c-e96b-4a35-a353-7a344f08935a	EPRWDPAY8	Telugu Wedding\t	t	2025-06-14 13:46:18.544+05:30	2025-06-14 13:46:18.544+05:30
25ebd76a-46be-4179-a349-90bb8a3cee41	E57XSUTMZ	Temple Rituals\t	t	2025-06-14 13:46:23.99+05:30	2025-06-14 13:46:23.99+05:30
14b7a100-bbe6-4b62-9934-799cd623b488	EKBW5GX2R	Temple Wedding\t	t	2025-06-14 13:46:30.809+05:30	2025-06-14 13:46:30.809+05:30
8c05acc8-029f-4e1c-bf2c-c225255a6f53	E69XTFTZM	Thread Ceremony\t	t	2025-06-14 13:46:38.839+05:30	2025-06-14 13:46:38.839+05:30
06109998-5705-4382-bbdd-f74a91d2200a	EFUYKW78J	Traditional Event 1\t	t	2025-06-14 13:46:47.08+05:30	2025-06-14 13:46:47.08+05:30
b818fc51-cb74-4e9d-ad5e-a66c080752d2	ECHE4SHJT	Traditional Event 2\t	t	2025-06-14 13:46:52.395+05:30	2025-06-14 13:46:52.395+05:30
20548962-9477-4693-9abd-0dfb7ce60835	ECHKGUF6U	Upanayanam\t	t	2025-06-14 13:46:56.833+05:30	2025-06-14 13:46:56.833+05:30
df919c90-9c8e-40ac-b169-7723f59f40f1	E5GVGVHA9	Uruthi Varthai\t	t	2025-06-14 13:47:04.034+05:30	2025-06-14 13:47:04.034+05:30
62b21176-f9b7-49e1-a79f-5d023967c35a	EMJERBKC9	Valima	t	2025-06-14 13:47:10.979+05:30	2025-06-14 13:47:10.979+05:30
ddbc3b37-7bee-4335-b3d1-a7e81482364b	E699B4NZD	Vara Pooja\t	t	2025-06-14 13:47:15.559+05:30	2025-06-14 13:47:15.559+05:30
c862eafd-174b-4d88-8c44-d484f6bcf865	ENWAC437X	Vilayadal\t	t	2025-06-14 13:47:24.91+05:30	2025-06-14 13:47:24.91+05:30
8ab8f9f0-d07c-49ce-a3df-399f7a4deb57	EYZ825DPJ	Vinayak Pooja\t	t	2025-06-14 13:47:36.299+05:30	2025-06-14 13:47:36.299+05:30
6c0202f0-754a-4367-800f-164a93db8885	E62MJNBXK	Viratham/Vratham	t	2025-06-14 13:47:50.588+05:30	2025-06-14 13:47:50.588+05:30
d6479484-f8db-43e1-8f9a-61a2bc29d7a3	E8TYW2S24	Virunthu	t	2025-06-14 13:47:59.041+05:30	2025-06-14 13:47:59.041+05:30
21259dcb-448d-4b13-acc5-bf2f0b8e8bcc	EBWYLV2HS	Vratham/Nichyathartham\t	t	2025-06-14 13:48:06.771+05:30	2025-06-14 13:48:06.771+05:30
f071f54b-27a0-420a-9990-82fd9103dc8e	E7L89S5UD	Wedding Anniversary\t	t	2025-06-14 13:48:17.093+05:30	2025-06-14 13:48:17.093+05:30
deea7cca-ffd8-449d-9197-817d0154cd1d	ECUHNDNR9	Welcoming Event\t	t	2025-06-14 13:48:23.853+05:30	2025-06-14 13:48:23.853+05:30
\.


--
-- Data for Name: instagram_analytics; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.instagram_analytics (id, date, total_messages, total_comments, total_mentions, total_story_mentions, new_leads_created, engagement_rate, response_time_minutes, metadata, created_at, updated_at) FROM stdin;
1	2025-06-18	3	3	2	2	2	85.50	0	{}	2025-06-19 12:38:48.234+05:30	2025-06-19 12:38:48.234+05:30
\.


--
-- Data for Name: instagram_comments; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.instagram_comments (id, comment_id, post_id, from_user_id, from_username, comment_text, parent_comment_id, is_from_client, metadata, created_time, created_at, updated_at) FROM stdin;
1	comment_001	post_12345	user_eventplanner	eventplanner_pro	This is gorgeous! Do you have packages for corporate events?	\N	t	{}	2025-06-19 09:38:48.231+05:30	2025-06-19 12:38:48.231+05:30	2025-06-19 12:38:48.231+05:30
2	comment_002	post_12346	user_wedding_blogger	weddingblogger	Love this setup! Can I feature this on my blog?	\N	t	{}	2025-06-19 07:38:48.231+05:30	2025-06-19 12:38:48.231+05:30	2025-06-19 12:38:48.231+05:30
3	comment_003	post_12347	user_photographer	photo_artist	Beautiful work! Would love to collaborate on future projects.	\N	t	{}	2025-06-18 12:38:48.231+05:30	2025-06-19 12:38:48.231+05:30	2025-06-19 12:38:48.231+05:30
4	comment_test_789	post_123	user_test_commenter	test_commenter	This is amazing! Do you work in Mumbai?	\N	t	{"post_info": {"post_id": "post_123"}, "comment_type": "post_comment"}	2024-01-01 15:30:00+05:30	2025-06-19 12:40:46.199+05:30	2025-06-19 12:40:46.199+05:30
\.


--
-- Data for Name: instagram_interactions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.instagram_interactions (id, interaction_type, user_id, target_message_id, content, metadata, "timestamp", created_at, updated_at) FROM stdin;
1	reaction	user_fashionlover23	ig_msg_001	❤️	{}	2025-06-19 10:38:48.234+05:30	2025-06-19 12:38:48.234+05:30	2025-06-19 12:38:48.234+05:30
2	reaction	user_startup_founder	ig_msg_002	👍	{}	2025-06-19 08:38:48.234+05:30	2025-06-19 12:38:48.234+05:30	2025-06-19 12:38:48.234+05:30
\.


--
-- Data for Name: instagram_mentions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.instagram_mentions (id, mention_id, from_user_id, from_username, mention_text, media_id, permalink, mention_type, metadata, created_time, created_at, updated_at) FROM stdin;
1	mention_001	user_influencer	lifestyle_influencer	Check out this amazing event setup by @yourbusiness!	media_789	\N	tag_mention	{}	2025-06-19 06:38:48.232+05:30	2025-06-19 12:38:48.232+05:30	2025-06-19 12:38:48.232+05:30
2	mention_002	user_client_happy	happy_client	Thank you @yourbusiness for making our wedding perfect!	media_790	\N	tag_mention	{}	2025-06-17 12:38:48.232+05:30	2025-06-19 12:38:48.232+05:30	2025-06-19 12:38:48.232+05:30
\.


--
-- Data for Name: instagram_messages; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.instagram_messages (id, message_id, from_user_id, to_user_id, content, message_type, attachment_metadata, is_from_client, "timestamp", created_at, updated_at) FROM stdin;
1	ig_msg_001	user_fashionlover23	business_account	Hi! I love your recent post about wedding decorations. Do you do destination weddings?	text	{}	t	2025-06-19 10:38:48.231+05:30	2025-06-19 12:38:48.231+05:30	2025-06-19 12:38:48.231+05:30
2	ig_msg_002	user_startup_founder	business_account	Interested in your social media management services. Can you send me a quote?	text	{}	t	2025-06-19 08:38:48.231+05:30	2025-06-19 12:38:48.231+05:30	2025-06-19 12:38:48.231+05:30
3	ig_msg_003	user_bride_to_be	business_account	Your portfolio looks amazing! When can we schedule a consultation?	text	{}	t	2025-06-18 12:38:48.231+05:30	2025-06-19 12:38:48.231+05:30	2025-06-19 12:38:48.231+05:30
\.


--
-- Data for Name: instagram_story_mentions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.instagram_story_mentions (id, mention_id, from_user_id, from_username, story_text, media_id, story_url, metadata, "timestamp", created_at, updated_at) FROM stdin;
1	story_001	user_vendor	vendor_partner	Great working with @yourbusiness team!	story_456	\N	{}	2025-06-19 00:38:48.233+05:30	2025-06-19 12:38:48.233+05:30	2025-06-19 12:38:48.233+05:30
2	story_002	user_satisfied_client	satisfied_client	Amazing service from @yourbusiness - highly recommend!	story_457	\N	{}	2025-06-18 12:38:48.233+05:30	2025-06-19 12:38:48.233+05:30	2025-06-19 12:38:48.233+05:30
\.


--
-- Data for Name: instruction_approvals; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.instruction_approvals (id, instruction_id, approval_status, approved_by, approved_at, comments, submitted_at, created_at) FROM stdin;
\.


--
-- Data for Name: lead_drafts; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.lead_drafts (id, phone, data, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: lead_followups; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.lead_followups (id, lead_id, scheduled_at, completed_at, contact_method, interaction_summary, status, outcome, notes, priority, created_by, created_at, updated_by, updated_at, completed_by, duration_minutes, follow_up_required, next_follow_up_date, followup_type, workflow_stage, quotation_id) FROM stdin;
\.


--
-- Data for Name: lead_sources; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.lead_sources (id, name, description, is_active, created_at, updated_at) FROM stdin;
1	Instagram	Instagram	t	2025-06-13 05:46:03.318+05:30	2025-06-13 05:46:03.318+05:30
\.


--
-- Data for Name: lead_task_performance; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.lead_task_performance (id, lead_id, task_id, response_time_hours, completion_time_hours, sla_met, revenue_impact, created_at) FROM stdin;
\.


--
-- Data for Name: leads; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.leads (id, lead_number, company_id, branch_id, client_name, email, country_code, phone, is_whatsapp, has_separate_whatsapp, whatsapp_country_code, whatsapp_number, notes, status, created_at, updated_at, assigned_to, lead_source, location, lead_source_id, rejection_reason, rejected_at, rejected_by, rejected_by_employee_id, assigned_to_uuid, previous_assigned_to, reassignment_date, reassignment_reason, is_reassigned, reassigned_at, reassigned_by, reassigned_from_company_id, reassigned_from_branch_id, bride_name, groom_name, priority, expected_value, last_contact_date, next_follow_up_date, conversion_stage, lead_score, tags, budget_range, wedding_date, venue_preference, guest_count, description, rejection_date) FROM stdin;
2	L0001	2	1	Ramya	vikas.alagarsamy1987@gmail.com	+91	9677362524	t	f	+91	9677362524	\N	ASSIGNED	2025-06-13 05:58:32.908+05:30	2025-06-13 14:36:52.048+05:30	6	Instagram	Chennai	1	\N	\N	\N	\N	\N	\N	\N	\N	t	2025-06-13 14:36:52.048+05:30	7	\N	\N	\N	\N	medium	0.00	\N	\N	new	50	\N	\N	\N	\N	\N	\N	\N
5	L0002	2	1	Jothi Alagarsamy	vikas@ooak.photography	+91	9677362524	t	f	+91	9677362524	\N	ASSIGNED	2025-06-14 06:00:51.482+05:30	2025-06-14 06:58:55.703+05:30	22	Instagram	Bengaluru	1	\N	\N	\N	\N	\N	\N	\N	\N	t	2025-06-14 06:58:55.703+05:30	7	\N	\N	\N	\N	medium	0.00	\N	\N	new	50	\N	\N	\N	\N	\N	\N	\N
6	L0003	2	1	Pradeep	pradeep@gmail.com	+91	9025303080	t	f	+91	9025303080	\N	ASSIGNED	2025-06-14 11:53:31.484+05:30	2025-06-14 11:54:30.197+05:30	6	Instagram	Jim Corbett	1	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	medium	0.00	\N	\N	new	50	\N	\N	\N	\N	\N	\N	\N
9	L0004	2	1	Dev	navyavikas14@gmail.com	+91	9677362524	t	f	+91	9677362524	\N	ASSIGNED	2025-06-14 15:17:03.971+05:30	2025-06-14 15:17:12.366+05:30	22	Instagram	Bengaluru	1	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	medium	0.00	\N	\N	new	50	\N	\N	\N	\N	\N	\N	\N
10	L0005	2	1	Abhi	navyavikas14@gmail.com	+91	9677362524	t	f	+91	9677362524	\N	REJECTED	2025-06-14 15:30:18.302+05:30	2025-06-14 15:58:43.042+05:30	22	Instagram	Bengaluru	1	Test rejection from API	2025-06-14 16:00:00+05:30	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	medium	0.00	\N	\N	new	50	\N	\N	\N	\N	\N	\N	\N
11	L0006	2	1	Harish	vikas@zgstudios.com	+91	9677362524	t	f	+91	9677362524	\N	ASSIGNED	2025-06-14 16:02:35.854+05:30	2025-06-14 16:02:41.678+05:30	22	Instagram	Belgaum	1	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	medium	0.00	\N	\N	new	50	\N	\N	\N	\N	\N	\N	\N
12	L0007	2	1	Navya Vikas	vikas.alagarsamy1987@gmail.com	+91	9677362524	t	f	+91	9677362524	\N	ASSIGNED	2025-06-17 21:58:41.049+05:30	2025-06-18 06:35:55.533+05:30	22	Instagram	Chennai	1	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	medium	0.00	\N	\N	new	50	\N	\N	\N	\N	\N	\N	\N
13	LD2024001	1	1	Priya Sharma	priya.sharma@gmail.com	\N	+91-9876543210	f	f	\N	\N	Contacted through Instagram. Interested in premium wedding package.	NEW	2025-06-19 12:50:32.706+05:30	2025-06-19 13:50:32.706+05:30	3	Instagram	Mumbai	1	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	Priya Sharma	Raj Patel	urgent	150000.00	\N	2025-06-19 04:50:32.706	new	90	{wedding,premium,instagram}	100k-200k	2024-12-14	Beach Resort, Goa	250	Premium wedding package for 250 guests. Beach wedding in Goa. High budget client, very interested.	\N
14	LD2024002	1	1	Tech Solutions Pvt Ltd	events@techsolutions.com	\N	+91-9876543211	f	f	\N	\N	Corporate event planning for annual conference.	CONTACTED	2025-06-14 13:50:32.706+05:30	2025-06-19 13:50:32.706+05:30	3	Website	Bangalore	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	high	80000.00	2025-06-17 02:50:32.706	2025-06-20 02:50:32.706	contacted	70	{corporate,conference,website}	50k-100k	\N	Convention Center, Bangalore	500	Annual tech conference for 500 attendees. Need full event management including catering, AV, and decor.	\N
15	LD2024003	1	1	Anita Reddy	anita.reddy@yahoo.com	\N	+91-9876543212	f	f	\N	\N	Engagement party planning. Friend referral.	CONTACTED	2025-06-07 13:50:32.706+05:30	2025-06-19 13:50:32.706+05:30	3	Referral	Hyderabad	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	Anita Reddy	Kiran Kumar	medium	45000.00	2025-06-09 02:50:32.706	2025-06-17 02:50:32.706	interested	60	{engagement,referral,party}	30k-50k	2024-11-19	Hotel Grand Palace, Hyderabad	150	Engagement ceremony for 150 guests. Traditional setup required with full catering.	\N
16	LD2024004	1	1	Global Corp International	events@globalcorp.com	\N	+91-9876543213	f	f	\N	\N	Multi-city corporate events. Quarterly meetings.	QUALIFIED	2025-06-11 13:50:32.706+05:30	2025-06-19 13:50:32.706+05:30	3	LinkedIn	Delhi	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	high	200000.00	2025-06-18 02:50:32.706	2025-06-22 02:50:32.706	quotation_sent	90	{corporate,multi-city,quarterly}	150k-250k	\N	Multiple venues across India	200	Quarterly corporate events across 5 cities. Premium corporate client with recurring business potential.	\N
17	LD2024005	1	1	Sunita Menon	sunita.menon@gmail.com	\N	+91-9876543214	f	f	\N	\N	Birthday party for daughter. Small budget.	NEW	2025-06-16 13:50:32.706+05:30	2025-06-19 13:50:32.706+05:30	3	Facebook	Chennai	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	low	15000.00	\N	2025-06-24 02:50:32.706	new	50	{birthday,family,budget}	10k-20k	\N	Community Hall, Chennai	80	Sweet 16 birthday party. Simple decorations and catering for 80 people.	\N
22	LEAD-02-587592	2	1	Sugeerth Murugesan	navyavikas14@gmail.com	+91	9480185770	t	f	+91	9480185770	\N	new	2025-06-20 17:09:47.592+05:30	2025-06-20 17:09:47.592+05:30	\N	Instagram	Jim Corbett	1	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	medium	0.00	\N	\N	new	50	\N	\N	\N	\N	\N	\N	\N
23	LEAD-02-906503	2	1	Durga	vikas@zgstudios.com	+91	9677362524	t	f	+91	9677362524	\N	ASSIGNED	2025-06-20 18:05:06.503+05:30	2025-06-20 18:28:34.298+05:30	22	Instagram	Chennai	1	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	medium	0.00	\N	\N	new	50	\N	\N	\N	\N	\N	\N	\N
24	L0NaN	2	1	Guru	navyavikas14@gmail.com	+91	9480185770	f	f	+91	9480185770	tes	UNASSIGNED	2025-06-23 07:18:32.769867+05:30	2025-06-23 07:18:32.769867+05:30	\N	Instagram	Chennai	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	medium	0	\N	\N	new	50	\N	100000-200000	2025-06-25	MRC	1000	tes	\N
25	L0008	2	1	Ramya	navyavikas14@gmail.com	+91	9480185770	f	f	+91	9480185770		UNASSIGNED	2025-06-23 09:05:40.30049+05:30	2025-06-23 09:05:40.30049+05:30	\N	Facebook	Chennai	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	low	0	\N	\N	new	50	\N	100000-200000	2025-06-24	MRC	1000	tetsing	\N
26	L0009	2	1	Abhi	vikas.alagarsamy1987@gmail.com	+91	9677362524	f	f	+91	9677362524		UNASSIGNED	2025-06-23 09:11:55.675721+05:30	2025-06-23 09:11:55.675721+05:30	\N	Referral	Japan	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	medium	0	\N	\N	new	50	\N	0-100000	2025-06-25	MRC	996	test	\N
27	L0010	2	1	Abhiya	vikas@zgstudios.com	+91	9500999861	t	f	+91	9500999861		UNASSIGNED	2025-06-23 09:16:49.327544+05:30	2025-06-23 09:16:49.327544+05:30	\N	Facebook	Namakkal	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	medium	0	\N	\N	new	50	\N	0-100000	2025-06-23		100		\N
28	L0011	2	1	Dev	pradeep@gmail.com	+91	9480185770	t	t	+91	9677362524		UNASSIGNED	2025-06-23 09:25:31.497185+05:30	2025-06-23 09:25:31.497185+05:30	\N	Facebook	Chennai	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	medium	0	\N	\N	new	50	\N	200000-500000	2025-06-23	TBD	1000		\N
29	L0012	2	4	Ramya	vikas@zgstudios.com	+91	9677362524	t	f	+91	9677362524	\N	UNASSIGNED	2025-06-23 09:31:45.675199+05:30	2025-06-23 09:31:45.675199+05:30	\N	Instagram	Chennai	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	Sushma	Kautilya Nalubolu	medium	0	\N	\N	new	50	\N	unspecified	\N	\N	\N	\N	\N
\.


--
-- Data for Name: management_insights; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.management_insights (id, insight_type, employee_id, priority, title, description, key_metrics, suggested_questions, recommended_actions, confidence_score, is_addressed, addressed_at, addressed_by, created_at, expires_at) FROM stdin;
2	process_improvement	\N	high	Team Conversion Rate Below Target	Overall team conversion rate is 0.0%, below the 60% target.	{"gap": 0.6, "target_rate": 0.6, "team_conversion_rate": 0}	["What are the main reasons quotes are not converting to sales?", "Are our pricing strategies competitive in the current market?", "Do sales reps have sufficient product knowledge and sales training?", "Are we qualifying leads properly before creating quotations?", "What tools or resources could help improve the sales process?", "How effective are our follow-up processes and timing?"]	["Analyze lost deals for common patterns", "Review and update sales training program", "Implement better lead qualification process", "Standardize follow-up procedures", "Review pricing and competitive positioning"]	0.8000	f	\N	\N	2025-06-13 13:29:02.381+05:30	\N
3	concern_alert	\N	medium	2 Sales Reps Have Low Activity Scores	Several team members are showing low activity levels, which may impact future performance.	{"low_activity_count": 2, "average_activity_score": 0}	["Are there any external factors affecting team motivation or activity levels?", "Do sales reps have enough qualified leads to work with?", "Are there any process inefficiencies slowing down sales activities?", "What tools or support could help increase productive activities?", "Are territory assignments balanced and realistic?"]	["Review lead generation and distribution", "Assess CRM and sales tool effectiveness", "Check for process bottlenecks", "Evaluate territory assignments", "Implement activity tracking improvements"]	0.7500	f	\N	\N	2025-06-13 13:29:02.383+05:30	\N
5	process_improvement	\N	high	Team Conversion Rate Below Target	Overall team conversion rate is 0.0%, below the 60% target.	{"gap": 0.6, "target_rate": 0.6, "team_conversion_rate": 0}	["What are the main reasons quotes are not converting to sales?", "Are our pricing strategies competitive in the current market?", "Do sales reps have sufficient product knowledge and sales training?", "Are we qualifying leads properly before creating quotations?", "What tools or resources could help improve the sales process?", "How effective are our follow-up processes and timing?"]	["Analyze lost deals for common patterns", "Review and update sales training program", "Implement better lead qualification process", "Standardize follow-up procedures", "Review pricing and competitive positioning"]	0.8000	f	\N	\N	2025-06-13 13:29:02.715+05:30	\N
6	concern_alert	\N	medium	2 Sales Reps Have Low Activity Scores	Several team members are showing low activity levels, which may impact future performance.	{"low_activity_count": 2, "average_activity_score": 0}	["Are there any external factors affecting team motivation or activity levels?", "Do sales reps have enough qualified leads to work with?", "Are there any process inefficiencies slowing down sales activities?", "What tools or support could help increase productive activities?", "Are territory assignments balanced and realistic?"]	["Review lead generation and distribution", "Assess CRM and sales tool effectiveness", "Check for process bottlenecks", "Evaluate territory assignments", "Implement activity tracking improvements"]	0.7500	f	\N	\N	2025-06-13 13:29:02.717+05:30	\N
8	process_improvement	\N	high	Team Conversion Rate Below Target	Overall team conversion rate is 0.0%, below the 60% target.	{"gap": 0.6, "target_rate": 0.6, "team_conversion_rate": 0}	["What are the main reasons quotes are not converting to sales?", "Are our pricing strategies competitive in the current market?", "Do sales reps have sufficient product knowledge and sales training?", "Are we qualifying leads properly before creating quotations?", "What tools or resources could help improve the sales process?", "How effective are our follow-up processes and timing?"]	["Analyze lost deals for common patterns", "Review and update sales training program", "Implement better lead qualification process", "Standardize follow-up procedures", "Review pricing and competitive positioning"]	0.8000	f	\N	\N	2025-06-18 16:04:02.476+05:30	\N
9	concern_alert	\N	medium	2 Sales Reps Have Low Activity Scores	Several team members are showing low activity levels, which may impact future performance.	{"low_activity_count": 2, "average_activity_score": 0}	["Are there any external factors affecting team motivation or activity levels?", "Do sales reps have enough qualified leads to work with?", "Are there any process inefficiencies slowing down sales activities?", "What tools or support could help increase productive activities?", "Are territory assignments balanced and realistic?"]	["Review lead generation and distribution", "Assess CRM and sales tool effectiveness", "Check for process bottlenecks", "Evaluate territory assignments", "Implement activity tracking improvements"]	0.7500	f	\N	\N	2025-06-18 16:04:02.478+05:30	\N
12	concern_alert	\N	medium	2 Sales Reps Have Low Activity Scores	Several team members are showing low activity levels, which may impact future performance.	{"low_activity_count": 2, "average_activity_score": 0}	["Are there any external factors affecting team motivation or activity levels?", "Do sales reps have enough qualified leads to work with?", "Are there any process inefficiencies slowing down sales activities?", "What tools or support could help increase productive activities?", "Are territory assignments balanced and realistic?"]	["Review lead generation and distribution", "Assess CRM and sales tool effectiveness", "Check for process bottlenecks", "Evaluate territory assignments", "Implement activity tracking improvements"]	0.7500	f	\N	\N	2025-06-18 16:04:02.509+05:30	\N
11	process_improvement	\N	high	Team Conversion Rate Below Target	Overall team conversion rate is 0.0%, below the 60% target.	{"gap": 0.6, "target_rate": 0.6, "team_conversion_rate": 0}	["What are the main reasons quotes are not converting to sales?", "Are our pricing strategies competitive in the current market?", "Do sales reps have sufficient product knowledge and sales training?", "Are we qualifying leads properly before creating quotations?", "What tools or resources could help improve the sales process?", "How effective are our follow-up processes and timing?"]	["Analyze lost deals for common patterns", "Review and update sales training program", "Implement better lead qualification process", "Standardize follow-up procedures", "Review pricing and competitive positioning"]	0.8000	f	\N	\N	2025-06-18 16:04:02.507+05:30	\N
14	process_improvement	\N	high	Team Conversion Rate Below Target	Overall team conversion rate is 0.0%, below the 60% target.	{"gap": 0.6, "target_rate": 0.6, "team_conversion_rate": 0}	["What are the main reasons quotes are not converting to sales?", "Are our pricing strategies competitive in the current market?", "Do sales reps have sufficient product knowledge and sales training?", "Are we qualifying leads properly before creating quotations?", "What tools or resources could help improve the sales process?", "How effective are our follow-up processes and timing?"]	["Analyze lost deals for common patterns", "Review and update sales training program", "Implement better lead qualification process", "Standardize follow-up procedures", "Review pricing and competitive positioning"]	0.8000	f	\N	\N	2025-06-18 16:16:17.738+05:30	\N
15	concern_alert	\N	medium	2 Sales Reps Have Low Activity Scores	Several team members are showing low activity levels, which may impact future performance.	{"low_activity_count": 2, "average_activity_score": 0}	["Are there any external factors affecting team motivation or activity levels?", "Do sales reps have enough qualified leads to work with?", "Are there any process inefficiencies slowing down sales activities?", "What tools or support could help increase productive activities?", "Are territory assignments balanced and realistic?"]	["Review lead generation and distribution", "Assess CRM and sales tool effectiveness", "Check for process bottlenecks", "Evaluate territory assignments", "Implement activity tracking improvements"]	0.7500	f	\N	\N	2025-06-18 16:16:17.741+05:30	\N
17	process_improvement	\N	high	Team Conversion Rate Below Target	Overall team conversion rate is 0.0%, below the 60% target.	{"gap": 0.6, "target_rate": 0.6, "team_conversion_rate": 0}	["What are the main reasons quotes are not converting to sales?", "Are our pricing strategies competitive in the current market?", "Do sales reps have sufficient product knowledge and sales training?", "Are we qualifying leads properly before creating quotations?", "What tools or resources could help improve the sales process?", "How effective are our follow-up processes and timing?"]	["Analyze lost deals for common patterns", "Review and update sales training program", "Implement better lead qualification process", "Standardize follow-up procedures", "Review pricing and competitive positioning"]	0.8000	f	\N	\N	2025-06-18 16:16:17.769+05:30	\N
18	concern_alert	\N	medium	2 Sales Reps Have Low Activity Scores	Several team members are showing low activity levels, which may impact future performance.	{"low_activity_count": 2, "average_activity_score": 0}	["Are there any external factors affecting team motivation or activity levels?", "Do sales reps have enough qualified leads to work with?", "Are there any process inefficiencies slowing down sales activities?", "What tools or support could help increase productive activities?", "Are territory assignments balanced and realistic?"]	["Review lead generation and distribution", "Assess CRM and sales tool effectiveness", "Check for process bottlenecks", "Evaluate territory assignments", "Implement activity tracking improvements"]	0.7500	f	\N	\N	2025-06-18 16:16:17.771+05:30	\N
20	process_improvement	\N	high	Team Conversion Rate Below Target	Overall team conversion rate is 0.0%, below the 60% target.	{"gap": 0.6, "target_rate": 0.6, "team_conversion_rate": 0}	["What are the main reasons quotes are not converting to sales?", "Are our pricing strategies competitive in the current market?", "Do sales reps have sufficient product knowledge and sales training?", "Are we qualifying leads properly before creating quotations?", "What tools or resources could help improve the sales process?", "How effective are our follow-up processes and timing?"]	["Analyze lost deals for common patterns", "Review and update sales training program", "Implement better lead qualification process", "Standardize follow-up procedures", "Review pricing and competitive positioning"]	0.8000	f	\N	\N	2025-06-18 16:16:36.718+05:30	\N
21	concern_alert	\N	medium	2 Sales Reps Have Low Activity Scores	Several team members are showing low activity levels, which may impact future performance.	{"low_activity_count": 2, "average_activity_score": 0}	["Are there any external factors affecting team motivation or activity levels?", "Do sales reps have enough qualified leads to work with?", "Are there any process inefficiencies slowing down sales activities?", "What tools or support could help increase productive activities?", "Are territory assignments balanced and realistic?"]	["Review lead generation and distribution", "Assess CRM and sales tool effectiveness", "Check for process bottlenecks", "Evaluate territory assignments", "Implement activity tracking improvements"]	0.7500	f	\N	\N	2025-06-18 16:16:36.72+05:30	\N
23	process_improvement	\N	high	Team Conversion Rate Below Target	Overall team conversion rate is 0.0%, below the 60% target.	{"gap": 0.6, "target_rate": 0.6, "team_conversion_rate": 0}	["What are the main reasons quotes are not converting to sales?", "Are our pricing strategies competitive in the current market?", "Do sales reps have sufficient product knowledge and sales training?", "Are we qualifying leads properly before creating quotations?", "What tools or resources could help improve the sales process?", "How effective are our follow-up processes and timing?"]	["Analyze lost deals for common patterns", "Review and update sales training program", "Implement better lead qualification process", "Standardize follow-up procedures", "Review pricing and competitive positioning"]	0.8000	f	\N	\N	2025-06-18 16:16:36.745+05:30	\N
24	concern_alert	\N	medium	2 Sales Reps Have Low Activity Scores	Several team members are showing low activity levels, which may impact future performance.	{"low_activity_count": 2, "average_activity_score": 0}	["Are there any external factors affecting team motivation or activity levels?", "Do sales reps have enough qualified leads to work with?", "Are there any process inefficiencies slowing down sales activities?", "What tools or support could help increase productive activities?", "Are territory assignments balanced and realistic?"]	["Review lead generation and distribution", "Assess CRM and sales tool effectiveness", "Check for process bottlenecks", "Evaluate territory assignments", "Implement activity tracking improvements"]	0.7500	f	\N	\N	2025-06-18 16:16:36.747+05:30	\N
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.menu_items (id, parent_id, name, description, icon, path, sort_order, is_visible, created_at, updated_at, string_id, section_name, is_admin_only, badge_text, badge_variant, is_new, category) FROM stdin;
1	\N	Core Business	Essential business operations	LayoutGrid	/core-business	1	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	core-business	\N	f	\N	secondary	f	primary
2	\N	Dashboard	Business overview	Home	/	1	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	dashboard	\N	f	\N	secondary	f	primary
3	1	🚀 AI Business Control	AI-powered business control	Cpu	/ai-business-control	2	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	ai-control	\N	f	\N	secondary	f	primary
4	\N	Sales & Revenue	Sales and revenue management	DollarSign	/sales	2	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-revenue	\N	f	\N	secondary	f	primary
5	4	Sales Dashboard	Sales performance overview	BarChart	/sales/dashboard	1	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-dashboard	\N	f	\N	secondary	f	primary
6	4	Create Lead	Create new leads	UserPlus	/sales/create-lead	2	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-create-lead	\N	f	\N	secondary	f	primary
7	4	My Leads	Personal lead management	Users	/sales/my-leads	3	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-my-leads	\N	f	\N	secondary	f	primary
8	4	Unassigned Leads	Leads pending assignment	UserMinus	/sales/unassigned	4	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-unassigned-leads	\N	f	\N	secondary	f	primary
9	4	Follow Up	Lead follow-up management	PhoneCall	/sales/follow-ups	5	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-follow-up	\N	f	\N	secondary	f	primary
10	4	Quotations	Quotation management	FileText	/sales/quotations	6	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-quotations	\N	f	\N	secondary	f	primary
11	4	Approval Queue	Pending approvals	Clock	/sales/approval-queue	7	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-approval-queue	\N	f	\N	secondary	f	primary
12	4	Rejected Quotes	Rejected quotations	X	/sales/rejected-quotes	8	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-rejected-quotes	\N	f	\N	secondary	f	primary
15	4	Lead Sources	Lead source tracking	Globe	/sales/sources	11	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-lead-sources	\N	f	\N	secondary	f	primary
19	4	Quotations Analytics	Quotation analysis	PieChart	/sales/quotations-analytics	15	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-quotations-analytics	\N	f	\N	secondary	f	primary
22	\N	Organization	Organization management	Building2	/organization	3	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	organization	\N	f	\N	secondary	f	primary
23	22	Companies	Company management	Building	/organization/companies	1	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	organization-companies	\N	f	\N	secondary	f	primary
24	22	Branches	Branch management	GitBranch	/organization/branches	2	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	organization-branches	\N	f	\N	secondary	f	primary
27	22	Vendors	Vendor management	Store	/organization/vendors	5	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	organization-vendors	\N	f	\N	secondary	f	primary
26	22	Suppliers	Supplier management	Truck	/organization/suppliers	4	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	organization-suppliers	\N	f	\N	secondary	f	primary
25	22	Clients	Client management	Users	/organization/clients	3	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	organization-clients	\N	f	\N	secondary	f	primary
28	22	Roles & Permissions	Access control	Shield	/organization/roles	6	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	organization-roles	\N	f	\N	secondary	f	primary
31	22	Menu Manager	Menu management	Menu	/organization/menu-manager	9	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	organization-menu-manager	\N	f	\N	secondary	f	primary
29	22	User Accounts	User management	User	/organization/user-accounts	7	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	organization-user-accounts	\N	f	\N	secondary	f	primary
30	22	Account Creation	Create new users	UserPlus	/organization/accounts/create	8	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	organization-account-creation	\N	f	\N	secondary	f	primary
32	\N	People & HR	HR management	Users	/people	4	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	people-hr	\N	f	\N	secondary	f	primary
33	32	People Dashboard	HR analytics	BarChart	/people/dashboard	1	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	people-dashboard	\N	f	\N	secondary	f	primary
34	32	Employees	Employee management	User	/people/employees	2	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	people-employees	\N	f	\N	secondary	f	primary
35	32	Departments	Department management	Grid	/people/departments	3	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	people-departments	\N	f	\N	secondary	f	primary
36	32	Designations	Role designations	Award	/people/designations	4	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	people-designations	\N	f	\N	secondary	f	primary
37	\N	Task Management	Task management	CheckSquare	/tasks	5	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	task-management	\N	f	\N	secondary	f	primary
38	37	My Tasks	Personal tasks	List	/tasks/my-tasks	1	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	tasks-my-tasks	\N	f	\N	secondary	f	primary
39	37	Task Control Center	Task oversight	Command	/tasks/control-center	2	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	tasks-control-center	\N	f	\N	secondary	f	primary
40	37	AI Task Generator	AI task creation	Cpu	/tasks/ai-generator	3	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	tasks-ai-generator	\N	f	\N	secondary	f	primary
41	37	Task Analytics	Task metrics	BarChart	/tasks/analytics	4	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	tasks-analytics	\N	f	\N	secondary	f	primary
42	37	Task Calendar	Task scheduling	Calendar	/tasks/calendar	5	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	tasks-calendar	\N	f	\N	secondary	f	primary
43	37	Task Reports	Task reporting	FileText	/tasks/reports	6	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	tasks-reports	\N	f	\N	secondary	f	primary
44	37	Task Sequence Management	Task workflow	GitBranch	/tasks/sequences	7	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	tasks-sequence-management	\N	f	\N	secondary	f	primary
45	37	Integration Status	System integration	Link2	/tasks/integrations	8	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	tasks-integration-status	\N	f	\N	secondary	f	primary
46	\N	Accounting & Finance	Financial management	DollarSign	/accounting	6	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	accounting-finance	\N	f	\N	secondary	f	primary
47	46	Financial Dashboard	Financial overview	BarChart	/accounting/dashboard	1	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	accounting-dashboard	\N	f	\N	secondary	f	primary
13	4	Order Confirmation	Order processing	Check	/sales/orders	9	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-order-confirmation	\N	f	\N	secondary	f	primary
14	4	Rejected Leads	Rejected leads	XCircle	/sales/rejected-leads	10	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	sales-rejected-leads	\N	f	\N	secondary	f	primary
48	46	Invoices	Invoice management	FileText	/accounting/invoices	2	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	accounting-invoices	\N	f	\N	secondary	f	primary
49	46	Payments	Payment processing	CreditCard	/accounting/payments	3	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	accounting-payments	\N	f	\N	secondary	f	primary
50	46	Expenses	Expense tracking	Receipt	/accounting/expenses	4	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	accounting-expenses	\N	f	\N	secondary	f	primary
51	\N	Event Coordination	Event management	Calendar	/events	7	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	event-coordination	\N	f	\N	secondary	f	primary
52	51	Events Dashboard	Event overview	BarChart	/events/dashboard	1	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	events-dashboard	\N	f	\N	secondary	f	primary
54	51	Events	Event management	Star	/events/list	3	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	events	\N	f	\N	secondary	f	primary
53	51	Event Calendar	Event scheduling	Calendar	/events/calendar	2	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	events-calendar	\N	f	\N	secondary	f	primary
55	51	Event Types	Event categories	Tag	/events/types	4	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	events-types	\N	f	\N	secondary	f	primary
56	51	Services	Event services	Tool	/events/services	5	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	events-services	\N	f	\N	secondary	f	primary
57	51	Venues	Event venues	MapPin	/events/venues	6	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	events-venues	\N	f	\N	secondary	f	primary
58	51	Staff Assignment	Event staffing	Users	/events/staff	7	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	events-staff	\N	f	\N	secondary	f	primary
68	\N	Post-Sales	Post-sales service	Handshake	/post-sales	9	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	post-sales	\N	f	\N	secondary	f	primary
69	68	Post-Sales Dashboard	Service overview	BarChart	/post-sales/dashboard	1	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	post-sales-dashboard	\N	f	\N	secondary	f	primary
70	68	Delivery Management	Delivery tracking	Truck	/post-sales/delivery	2	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	post-sales-delivery	\N	f	\N	secondary	f	primary
71	68	Customer Support	Customer service	Headphones	/post-sales/support	3	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	post-sales-support	\N	f	\N	secondary	f	primary
72	68	Customer Feedback	Feedback management	MessageSquare	/post-sales/feedback	4	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	post-sales-feedback	\N	f	\N	secondary	f	primary
73	\N	Reports & Analytics	Business analytics	PieChart	/reports	10	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	reports-analytics	\N	f	\N	secondary	f	primary
20	4	Lead Source Analysis	Lead source metrics	BarChart2	/sales/lead-source-analysis	16	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	reports-lead-sources	\N	f	\N	secondary	f	primary
21	4	Conversion Funnel	Conversion analysis	Filter	/sales/conversion-funnel	17	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	reports-conversion-funnel	\N	f	\N	secondary	f	primary
18	4	Team Performance	Team metrics	TrendingUp	/sales/team-performance	14	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	reports-team-performance	\N	f	\N	secondary	f	primary
77	73	Business Trends	Trend analysis	LineChart	/reports/trends	4	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	reports-trends	\N	f	\N	secondary	f	primary
78	73	Custom Reports	Custom reporting	FileText	/reports/custom	5	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	reports-custom	\N	f	\N	secondary	f	primary
79	\N	System Administration	System administration	Settings	/admin	11	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	system-administration	\N	f	\N	secondary	f	primary
59	\N	Post Production	Production management	Film	/production	8	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	post-production	\N	f	\N	secondary	f	primary
60	59	Production Dashboard	Production overview	BarChart	/production/dashboard	1	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	post-production-dashboard	\N	f	\N	secondary	f	primary
61	59	Deliverables	Project deliverables	Package	/production/deliverables	2	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	post-production-deliverables	\N	f	\N	secondary	f	primary
62	59	Deliverables Workflow	Delivery workflow	GitBranch	/production/workflow	3	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	post-production-deliverables-workflow	\N	f	\N	secondary	f	primary
63	59	Projects	Project management	Folder	/production/projects	4	t	2025-06-12 23:01:21.543+05:30	2025-06-18 17:32:26.533+05:30	post-production-projects	\N	f	\N	secondary	f	primary
80	79	Menu Permissions	\N	Settings	/admin/menu-permissions	10	t	2025-06-22 22:43:33.29028+05:30	2025-06-22 22:43:33.29028+05:30	menu-permissions	Configuration	t	\N	secondary	f	primary
\.


--
-- Data for Name: menu_items_tracking; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.menu_items_tracking (id, menu_item_id, last_known_state, last_updated) FROM stdin;
\.


--
-- Data for Name: message_analysis; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.message_analysis (id, message_id, sentiment, sentiment_score, intent, urgency_level, key_topics, recommended_action, confidence_score, ai_model_version, created_at) FROM stdin;
\.


--
-- Data for Name: ml_model_performance; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.ml_model_performance (id, model_name, model_version, metric_type, metric_value, dataset_size, training_date, evaluation_date, is_production_model) FROM stdin;
\.


--
-- Data for Name: notification_batches; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.notification_batches (id, user_id, notification_type, batch_key, last_sent, count, metadata) FROM stdin;
\.


--
-- Data for Name: notification_engagement; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.notification_engagement (id, notification_id, user_id, event_type, engagement_data, created_at) FROM stdin;
\.


--
-- Data for Name: notification_patterns; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.notification_patterns (id, type, frequency, engagement_rate, optimal_timing, user_segments, success_metrics, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notification_preferences; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.notification_preferences (user_id, email_notifications, push_notifications, permission_changes, role_assignments, admin_role_changes, security_permission_changes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notification_recipients; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.notification_recipients (notification_id, user_id, is_read, is_dismissed, created_at) FROM stdin;
\.


--
-- Data for Name: notification_rules; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.notification_rules (id, name, trigger_type, conditions, recipients, template_id, enabled, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notification_settings; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.notification_settings (user_id, email_enabled, in_app_enabled, overdue_alerts, approval_alerts, payment_alerts, automation_alerts, email_frequency, quiet_hours_start, quiet_hours_end, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.notifications (id, type, priority, title, message, quotation_id, is_read, created_at, expires_at, action_url, action_label, metadata, scheduled_for, ai_enhanced, recipient_role, recipient_id, data, read_at, target_user, employee_id) FROM stdin;
notif_1749776392828_sxj1ng4kg	client_followup	high	🔔 Task Reminder: Initial contact with Ramya	DUE TOMORROW - Make initial contact with Ramya (Lead #L0001). Introduce yourself, understand their requirements, and schedule a detailed discussion. This is a fresh lead that needs immediate attention.. Reminder sent by admin.	\N	t	2025-06-13 06:29:52.828+05:30	\N	/tasks/dashboard?focus=1	View Task	{"task_id": 1, "due_date": "2025-06-14T00:29:19.685+00:00", "priority": "medium", "task_title": "Initial contact with Ramya", "reminded_by": "1", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T00:59:52.828Z", "reminded_by_username": "admin"}	2025-06-13 06:29:52.829+05:30	f	\N	\N	\N	\N	\N	22
notif_1749775239666_kjis8dpa1	client_followup	high	🔔 Task Reminder: Initial contact with Ramya	DUE TOMORROW - Make initial contact with Ramya (Lead #L0001). Introduce yourself, understand their requirements, and schedule a detailed discussion. This is a fresh lead that needs immediate attention.. Reminder sent by admin.	\N	t	2025-06-13 06:10:39.666+05:30	\N	/tasks/dashboard?focus=1	View Task	{"task_id": 1, "due_date": "2025-06-14T00:29:19.685+00:00", "priority": "medium", "task_title": "Initial contact with Ramya", "reminded_by": "1", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T00:40:39.666Z", "reminded_by_username": "admin"}	2025-06-13 06:10:39.665+05:30	f	\N	\N	\N	\N	\N	22
notif_1749775162054_796eo0c6b	client_followup	high	🔔 Task Reminder: Initial contact with Ramya	DUE TOMORROW - Make initial contact with Ramya (Lead #L0001). Introduce yourself, understand their requirements, and schedule a detailed discussion. This is a fresh lead that needs immediate attention.. Reminder sent by admin.	\N	t	2025-06-13 06:09:22.054+05:30	\N	/tasks/dashboard?focus=1	View Task	{"task_id": 1, "due_date": "2025-06-14T00:29:19.685+00:00", "priority": "medium", "task_title": "Initial contact with Ramya", "reminded_by": "1", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T00:39:22.054Z", "reminded_by_username": "admin"}	2025-06-13 06:09:22.054+05:30	f	\N	\N	\N	\N	\N	6
notif_1749780199132_m2zzn5ka3	client_followup	high	🔔 Task Reminder: Initial contact with Ramya	DUE TOMORROW - Make initial contact with Ramya (Lead #L0001). Introduce yourself, understand their requirements, and schedule a detailed discussion. This is a fresh lead that needs immediate attention.. Reminder sent by durga.ooak.	\N	t	2025-06-13 07:33:19.132+05:30	\N	/tasks/dashboard?focus=1	View Task	{"task_id": 1, "due_date": "2025-06-14T00:29:19.685+00:00", "priority": "medium", "task_title": "Initial contact with Ramya", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T02:03:19.132Z", "reminded_by_username": "durga.ooak"}	2025-06-13 07:33:19.134+05:30	f	\N	\N	\N	\N	\N	22
notif_1749801393367_bflkg39vy	client_followup	high	🔔 Task Reminder: Review revised quotation for Ramya	DUE TOMORROW - Review the revised ₹245,000 quotation QT-2025-0001 for Ramya. This quotation was previously rejected and has now been updated.. Reminder sent by durga.ooak.	\N	t	2025-06-13 13:26:33.367+05:30	\N	/tasks/dashboard?focus=28	View Task	{"task_id": 28, "due_date": "2025-06-14T07:56:16.866+00:00", "priority": "high", "task_title": "Review revised quotation for Ramya", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T07:56:33.367Z", "reminded_by_username": "durga.ooak"}	2025-06-13 13:26:33.368+05:30	f	\N	\N	\N	\N	\N	7
notif_1749796872393_ymzdjanph	client_followup	high	🔔 Task Reminder: Revise quotation for Ramya - Quote Rejected (QT-2025-0001)	DUE TOMORROW - 🚨 QUOTATION REJECTED by Sales Head\n\n**Quotation Details:**\n- Quotation Number: QT-2025-0001\n- Client: Ramya\n- Amount: ₹210,000\n\n**Rejection Reason:**\nTesting the approval workflow - please revise the quotation\n\n**Required Actions:**\n1. Review the rejection feedback above\n2. Revise the quotation based on feedback\n3. Resubmit for approval\n\n**Quick Actions:**\n- Edit Quotation: /quotations/edit/1\n- View Original: /quotations/view/QT-2025-0001. Reminder sent by durga.ooak.	\N	t	2025-06-13 12:11:12.393+05:30	\N	/tasks/dashboard?focus=15	View Task	{"task_id": 15, "due_date": "2025-06-14T06:39:56+00:00", "priority": "urgent", "task_title": "Revise quotation for Ramya - Quote Rejected (QT-2025-0001)", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T06:41:12.393Z", "reminded_by_username": "durga.ooak"}	2025-06-13 12:11:12.395+05:30	f	\N	\N	\N	\N	\N	22
notif_1749797244310_nu8cn3rh3	client_followup	high	🔔 Task Reminder: Revise quotation for Ramya - Quote Rejected (QT-2025-0001)	DUE TOMORROW - 🚨 QUOTATION REJECTED by Sales Head\n\n**Quotation Details:**\n- Quotation Number: QT-2025-0001\n- Client: Ramya\n- Amount: ₹280,000\n\n**Rejection Reason:**\nrejected\n\n**Required Actions:**\n1. Review the rejection feedback above\n2. Revise the quotation based on feedback\n3. Resubmit for approval\n\n**Quick Actions:**\n- Edit Quotation: /quotations/edit/1\n- View Original: /quotations/view/QT-2025-0001. Reminder sent by durga.ooak.	\N	t	2025-06-13 12:17:24.31+05:30	\N	/tasks/dashboard?focus=19	View Task	{"task_id": 19, "due_date": "2025-06-14T06:46:56.516+00:00", "priority": "urgent", "task_title": "Revise quotation for Ramya - Quote Rejected (QT-2025-0001)", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T06:47:24.309Z", "reminded_by_username": "durga.ooak"}	2025-06-13 12:17:24.31+05:30	f	\N	\N	\N	\N	\N	22
notif_1749863775161_1240xsedt	client_followup	high	🔔 Task Reminder: 📞 Follow up with Jothi Alagarsamy - Quote Approved	DUE TOMORROW - The quotation QT-2025-0002 for ₹75,000 has been approved and sent to the client via WhatsApp. \n\n**Your Action Required:**\n1. Call the client within 24 hours to discuss the quotation\n2. Answer any questions they may have\n3. Negotiate pricing if needed\n4. Update the quotation amount if client requests changes\n5. Guide them through the booking process\n\n**Client Details:**\n- Name: Jothi Alagarsamy\n- Phone: +91 9677362524\n- Amount: ₹75,000\n- Package: basic\n\n**Next Steps:**\n- If client agrees: Guide them to make advance payment\n- If client wants changes: Update quotation and resubmit for approval\n- If client declines: Mark task as completed with reason. Reminder sent by durga.ooak.	\N	t	2025-06-14 06:46:15.161+05:30	\N	/tasks/dashboard?focus=43	View Task	{"task_id": 43, "due_date": "2025-06-15T01:14:04.16+00:00", "priority": "high", "task_title": "📞 Follow up with Jothi Alagarsamy - Quote Approved", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-14T01:16:15.160Z", "reminded_by_username": "durga.ooak"}	2025-06-14 06:46:15.163+05:30	f	\N	\N	\N	\N	\N	6
notif_1749878476802_fuiqfjxmd	client_followup	high	🔔 Task Reminder: Review quotation edit for Jothi Alagarsamy - Amount Updated	DUE TOMORROW - Review the updated ₹1,45,000 quotation QT-2025-0002 for Jothi Alagarsamy. The quotation amount has been increased from ₹95,000 to ₹1,45,000 due to additional services (Candid Videography). Please review and approve the changes.. Reminder sent by durga.ooak.	\N	f	2025-06-14 10:51:16.802+05:30	\N	/tasks/dashboard?focus=44	View Task	{"task_id": 44, "due_date": "2025-06-15T04:03:56.611+00:00", "priority": "high", "task_title": "Review quotation edit for Jothi Alagarsamy - Amount Updated", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-14T05:21:16.802Z", "reminded_by_username": "durga.ooak"}	2025-06-14 10:51:16.803+05:30	f	\N	\N	\N	\N	\N	7
notif_1749814029400_e58ztxwgv	client_followup	high	🔔 Task Reminder: Initial contact with Kruthika	DUE TOMORROW - Make initial contact with Kruthika (Lead #L0002). Introduce yourself, understand their requirements, and schedule a detailed discussion. This is a fresh lead that needs immediate attention.. Reminder sent by durga.ooak.	\N	t	2025-06-13 16:57:09.4+05:30	\N	/tasks/dashboard?focus=33	View Task	{"task_id": 33, "due_date": "2025-06-14T11:25:52.593+00:00", "priority": "medium", "task_title": "Initial contact with Kruthika", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T11:27:09.400Z", "reminded_by_username": "durga.ooak"}	2025-06-13 16:57:09.401+05:30	f	\N	\N	\N	\N	\N	6
notif_1749798354220_8kgypiya3	client_followup	high	🔔 Task Reminder: Revise quotation for Ramya - Quote Rejected (QT-2025-0001)	DUE TOMORROW - 🚨 QUOTATION REJECTED by Sales Head\n\n**Quotation Details:**\n- Quotation Number: QT-2025-0001\n- Client: Ramya\n- Amount: ₹280,000\n\n**Rejection Reason:**\nrejected\n\n**Required Actions:**\n1. Review the rejection feedback above\n2. Revise the quotation based on feedback\n3. Resubmit for approval\n\n**Quick Actions:**\n- Edit Quotation: /quotations/edit/1\n- View Original: /quotations/view/QT-2025-0001. Reminder sent by durga.ooak.	\N	t	2025-06-13 12:35:54.22+05:30	\N	/tasks/dashboard?focus=19	View Task	{"task_id": 19, "due_date": "2025-06-14T06:46:56.516+00:00", "priority": "urgent", "task_title": "Revise quotation for Ramya - Quote Rejected (QT-2025-0001)", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T07:05:54.220Z", "reminded_by_username": "durga.ooak"}	2025-06-13 12:35:54.221+05:30	f	\N	\N	\N	\N	\N	22
notif_1749799506432_ud6dfsqt6	client_followup	high	🔔 Task Reminder: Review revised quotation for Ramya	DUE TOMORROW - Review the revised ₹250,000 quotation QT-2025-0001 for Ramya. This quotation was previously rejected and has now been updated.. Reminder sent by durga.ooak.	\N	t	2025-06-13 12:55:06.432+05:30	\N	/tasks/dashboard?focus=22	View Task	{"task_id": 22, "due_date": "2025-06-14T07:24:40.675+00:00", "priority": "high", "task_title": "Review revised quotation for Ramya", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T07:25:06.431Z", "reminded_by_username": "durga.ooak"}	2025-06-13 12:55:06.432+05:30	f	\N	\N	\N	\N	\N	7
notif_1749800355156_0iakydu42	client_followup	high	🔔 Task Reminder: Revise quotation for Ramya - Quote Rejected (QT-2025-0001)	DUE TOMORROW - 🚨 QUOTATION REJECTED by Sales Head\n\n**Quotation Details:**\n- Quotation Number: QT-2025-0001\n- Client: Ramya\n- Amount: ₹250,000\n\n**Rejection Reason:**\nrejected by vikas alagarsamy\n\n**Required Actions:**\n1. Review the rejection feedback above\n2. Revise the quotation based on feedback\n3. Resubmit for approval\n\n**Quick Actions:**\n- Edit Quotation: /quotations/edit/1\n- View Original: /quotations/view/QT-2025-0001. Reminder sent by durga.ooak.	\N	t	2025-06-13 13:09:15.156+05:30	\N	/tasks/dashboard?focus=23	View Task	{"task_id": 23, "due_date": "2025-06-14T07:25:49.567+00:00", "priority": "urgent", "task_title": "Revise quotation for Ramya - Quote Rejected (QT-2025-0001)", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T07:39:15.155Z", "reminded_by_username": "durga.ooak"}	2025-06-13 13:09:15.156+05:30	f	\N	\N	\N	\N	\N	22
notif_1749800590527_7rn3xhgc4	client_followup	high	🔔 Task Reminder: Revise quotation for Ramya - Quote Rejected (QT-2025-0001)	DUE TOMORROW - 🚨 QUOTATION REJECTED by Sales Head\n\n**Quotation Details:**\n- Quotation Number: QT-2025-0001\n- Client: Ramya\n- Amount: ₹265,000\n\n**Rejection Reason:**\nchange it\n\n**Required Actions:**\n1. Review the rejection feedback above\n2. Revise the quotation based on feedback\n3. Resubmit for approval\n\n**Quick Actions:**\n- Edit Quotation: /quotations/edit/1\n- View Original: /quotations/view/QT-2025-0001. Reminder sent by durga.ooak.	\N	t	2025-06-13 13:13:10.527+05:30	\N	/tasks/dashboard?focus=25	View Task	{"task_id": 25, "due_date": "2025-06-14T07:41:09.757+00:00", "priority": "urgent", "task_title": "Revise quotation for Ramya - Quote Rejected (QT-2025-0001)", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T07:43:10.527Z", "reminded_by_username": "durga.ooak"}	2025-06-13 13:13:10.528+05:30	f	\N	\N	\N	\N	\N	6
notif_1749800808231_jjj2kjjln	client_followup	high	🔔 Task Reminder: Revise quotation for Ramya - Quote Rejected (QT-2025-0001)	DUE TOMORROW - 🚨 QUOTATION REJECTED by Sales Head\n\n**Quotation Details:**\n- Quotation Number: QT-2025-0001\n- Client: Ramya\n- Amount: ₹265,000\n\n**Rejection Reason:**\nrejected\n\n**Required Actions:**\n1. Review the rejection feedback above\n2. Revise the quotation based on feedback\n3. Resubmit for approval\n\n**Quick Actions:**\n- Edit Quotation: /quotations/edit/1\n- View Original: /quotations/view/QT-2025-0001. Reminder sent by durga.ooak.	\N	t	2025-06-13 13:16:48.231+05:30	\N	/tasks/dashboard?focus=27	View Task	{"task_id": 27, "due_date": "2025-06-14T07:45:23.187+00:00", "priority": "urgent", "task_title": "Revise quotation for Ramya - Quote Rejected (QT-2025-0001)", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T07:46:48.231Z", "reminded_by_username": "durga.ooak"}	2025-06-13 13:16:48.23+05:30	f	\N	\N	\N	\N	\N	6
notif_1749801348023_07xhqwhpt	client_followup	high	🔔 Task Reminder: Revise quotation for Ramya - Quote Rejected (QT-2025-0001)	DUE TOMORROW - 🚨 QUOTATION REJECTED by Sales Head\n\n**Quotation Details:**\n- Quotation Number: QT-2025-0001\n- Client: Ramya\n- Amount: ₹265,000\n\n**Rejection Reason:**\nrejected\n\n**Required Actions:**\n1. Review the rejection feedback above\n2. Revise the quotation based on feedback\n3. Resubmit for approval\n\n**Quick Actions:**\n- Edit Quotation: /quotations/edit/1\n- View Original: /quotations/view/QT-2025-0001. Reminder sent by durga.ooak.	\N	t	2025-06-13 13:25:48.023+05:30	\N	/tasks/dashboard?focus=27	View Task	{"task_id": 27, "due_date": "2025-06-14T07:45:23.187+00:00", "priority": "urgent", "task_title": "Revise quotation for Ramya - Quote Rejected (QT-2025-0001)", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T07:55:48.022Z", "reminded_by_username": "durga.ooak"}	2025-06-13 13:25:48.024+05:30	f	\N	\N	\N	\N	\N	6
notif_1749801454898_54nsghcgf	client_followup	high	🔔 Task Reminder: Revise quotation for Ramya - Quote Rejected (QT-2025-0001)	DUE TOMORROW - 🚨 QUOTATION REJECTED by Sales Head\n\n**Quotation Details:**\n- Quotation Number: QT-2025-0001\n- Client: Ramya\n- Amount: ₹245,000\n\n**Rejection Reason:**\nrejected\n\n**Required Actions:**\n1. Review the rejection feedback above\n2. Revise the quotation based on feedback\n3. Resubmit for approval\n\n**Quick Actions:**\n- Edit Quotation: /quotations/edit/1\n- View Original: /quotations/view/QT-2025-0001. Reminder sent by durga.ooak.	\N	t	2025-06-13 13:27:34.898+05:30	\N	/tasks/dashboard?focus=29	View Task	{"task_id": 29, "due_date": "2025-06-14T07:56:48.527+00:00", "priority": "urgent", "task_title": "Revise quotation for Ramya - Quote Rejected (QT-2025-0001)", "reminded_by": "6", "task_status": "pending", "days_until_due": 1, "reminder_sent_at": "2025-06-13T07:57:34.896Z", "reminded_by_username": "durga.ooak"}	2025-06-13 13:27:34.899+05:30	f	\N	\N	\N	\N	\N	6
\.


--
-- Data for Name: partners; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.partners (id, name, contact_person, email, phone, address, partnership_type, partnership_start_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.payments (id, quotation_id, amount, payment_type, payment_method, payment_reference, paid_by, status, received_at, created_at, updated_at) FROM stdin;
2	1	5000.00	advance	UPI	test123	Test Client	received	2025-06-19 13:18:23.911+05:30	2025-06-19 13:18:23.911+05:30	2025-06-19 13:18:23.908+05:30
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.permissions (id, name, description, category, resource, action, created_at, updated_at, status) FROM stdin;
\.


--
-- Data for Name: personalization_learning; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.personalization_learning (id, user_id, interaction_type, interaction_data, outcome_positive, learning_weight, context_tags, session_id, created_at) FROM stdin;
\.


--
-- Data for Name: post_sale_confirmations; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.post_sale_confirmations (id, quotation_id, confirmed_by_user_id, confirmation_date, call_date, call_time, call_duration, client_contact_person, confirmation_method, services_confirmed, deliverables_confirmed, event_details_confirmed, client_satisfaction_rating, client_expectations, client_concerns, additional_requests, call_summary, action_items, follow_up_required, follow_up_date, attachments, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: post_sales_workflows; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.post_sales_workflows (id, quotation_id, payment_id, instruction_id, client_name, status, instructions, confirmed_by, confirmed_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: predictive_insights; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.predictive_insights (id, user_id, insight_type, probability, recommended_action, trigger_conditions, estimated_impact, status, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.profiles (id, full_name, avatar_url, job_title, department, location, phone, bio, employee_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: query_performance_logs; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.query_performance_logs (id, view_name, rows_returned, execution_time_ms, created_at) FROM stdin;
\.


--
-- Data for Name: quotation_approvals; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quotation_approvals (id, quotation_id, approval_status, approval_date, comments, price_adjustments, created_at, updated_at, approver_user_id) FROM stdin;
1	1	pending	\N	Auto-submitted from task completion (Task ID: 1)	\N	2025-06-12 22:45:15.984	2025-06-13 03:19:14.047	7
2	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹90,000	\N	2025-06-13 00:28:15.15	2025-06-13 03:19:14.047	7
3	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹90,000	\N	2025-06-13 00:28:59.09	2025-06-13 03:19:14.047	7
4	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹90,000	\N	2025-06-13 00:30:02.16	2025-06-13 03:19:14.047	7
5	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹90,000	\N	2025-06-13 00:30:35.123	2025-06-13 03:19:14.047	7
6	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹140,000	\N	2025-06-13 00:43:17.868	2025-06-13 03:19:14.047	7
7	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹140,000	\N	2025-06-13 00:45:00.02	2025-06-13 03:19:14.047	7
8	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹140,000	\N	2025-06-13 00:48:18.318	2025-06-13 03:19:14.047	7
9	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹140,000	\N	2025-06-13 00:49:35.237	2025-06-13 03:19:14.047	7
10	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹140,000	\N	2025-06-13 00:50:31.477	2025-06-13 03:19:14.047	7
11	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹210,000	\N	2025-06-13 01:02:11.726	2025-06-13 03:19:14.047	7
12	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹280,000	\N	2025-06-13 01:11:57.982	2025-06-13 03:19:14.047	7
13	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹280,000	\N	2025-06-13 01:14:50.55	2025-06-13 03:19:14.047	7
14	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹280,000	\N	2025-06-13 01:37:14.956	2025-06-13 03:19:14.047	7
15	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹250,000	\N	2025-06-13 01:54:40.67	2025-06-13 03:19:14.047	7
16	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹265,000	\N	2025-06-13 02:09:45.256	2025-06-13 03:19:14.047	7
17	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹265,000	\N	2025-06-13 02:14:08.43	2025-06-13 03:19:14.047	7
18	1	pending	\N	Revised quotation resubmitted for approval. Updated amount: ₹245,000	\N	2025-06-13 02:26:16.86	2025-06-13 03:19:14.047	7
20	1	approved	2025-06-13 03:40:16.872	Aprpoved	\N	2025-06-13 03:40:16.872	2025-06-13 03:40:16.872	7
21	1	approved	2025-06-13 03:45:41.632	Test approval - WhatsApp should be sent to client	\N	2025-06-13 03:45:41.632	2025-06-13 03:45:41.632	7
22	1	approved	2025-06-13 04:30:47.853	Test approval with AI follow-up system	\N	2025-06-13 04:30:47.853	2025-06-13 04:30:47.853	7
26	3	pending	\N	Manual workflow trigger for testing (Task ID: 40)	\N	2025-06-13 19:18:10.051	2025-06-13 19:18:10.051	7
27	3	pending	\N	Manual workflow trigger for testing (Task ID: 40)	\N	2025-06-13 19:18:49.211	2025-06-13 19:18:49.211	7
28	3	pending	\N	Manual workflow trigger for testing (Task ID: 40)	\N	2025-06-13 19:19:41.983	2025-06-13 19:19:41.983	7
29	3	rejected	2025-06-13 19:23:53.578	rejected	\N	2025-06-13 19:23:53.578	2025-06-13 19:23:53.578	7
30	3	approved	2025-06-13 19:38:43.375	Test approval - checking post-approval workflow	\N	2025-06-13 19:38:43.375	2025-06-13 19:38:43.375	7
31	3	rejected	2025-06-13 23:36:03.994	rejected	\N	2025-06-13 23:36:03.994	2025-06-13 23:36:03.994	7
33	3	rejected	2025-06-13 23:45:49.159	rejected.. But less	\N	2025-06-13 23:45:49.159	2025-06-13 23:45:49.159	7
34	1	approved	2025-06-13 23:51:36.273	approved	\N	2025-06-13 23:51:36.273	2025-06-13 23:51:36.273	7
37	3	rejected	2025-06-14 00:46:01.173	rejected	\N	2025-06-14 00:46:01.173	2025-06-14 00:46:01.173	7
38	4	pending	\N	Auto-submitted from task completion (Task ID: 55)	\N	2025-06-14 01:07:02.071	2025-06-14 01:07:02.071	7
39	4	rejected	2025-06-14 01:07:46.38	rejected	\N	2025-06-14 01:07:46.38	2025-06-14 01:07:46.38	7
42	4	rejected	2025-06-14 01:29:28.809	rejected byv ikas	\N	2025-06-14 01:29:28.809	2025-06-14 01:29:28.809	7
45	4	rejected	2025-06-14 01:37:33.998	rejected by vikas	\N	2025-06-14 01:37:33.998	2025-06-14 01:37:33.998	7
47	4	approved	2025-06-14 01:39:33.039	approved	\N	2025-06-14 01:39:33.039	2025-06-14 01:39:33.039	7
48	5	pending	\N	Auto-submitted from task completion (Task ID: 87)	\N	2025-06-14 04:49:02.567	2025-06-14 04:49:02.567	7
49	5	rejected	2025-06-14 04:49:24.192	test	\N	2025-06-14 04:49:24.192	2025-06-14 04:49:24.192	7
50	1	approved	2025-06-19 08:04:08.449	Approved for testing - Phase 12 migration	\N	2025-06-19 08:04:08.449	2025-06-19 08:04:08.449	7
\.


--
-- Data for Name: quotation_business_lifecycle; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quotation_business_lifecycle (id, quotation_id, current_stage, stage_history, probability_score, last_client_interaction, next_follow_up_due, days_in_pipeline, revision_count, ai_insights, created_at, updated_at) FROM stdin;
26	4	follow_up_active	{"{\\"notes\\": \\"Quotation initially created\\", \\"stage\\": \\"quotation_sent\\", \\"timestamp\\": \\"2025-06-14T06:37:02.035639+00:00\\"}","{\\"notes\\": \\"Quotation approved, follow-up phase started\\", \\"stage\\": \\"follow_up_active\\", \\"timestamp\\": \\"2025-06-14T07:09:35.189Z\\"}"}	75	2025-06-14 01:39:35.189	2025-06-15 01:39:35.189	0	0	Quotation recently approved. Initial follow-up phase to monitor client engagement and ensure successful conversion.	2025-06-14 01:39:35.189	2025-06-14 01:39:35.189
\.


--
-- Data for Name: quotation_edit_approvals; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quotation_edit_approvals (id, quotation_id, requested_by, approved_by, original_data, modified_data, changes_summary, edit_reason, original_amount, modified_amount, amount_difference, percentage_change, approval_status, approval_date, approval_comments, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: quotation_events; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quotation_events (id, quotation_id, event_name, event_date, event_location, venue_name, start_time, end_time, expected_crowd, selected_package, selected_services, selected_deliverables, service_overrides, package_overrides, created_at) FROM stdin;
18	1	Wedding	2025-06-25 00:00:00+05:30	Chennai	Grand Palace	09:00	18:00	200-300	elite	[{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}]	[{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 4, "quantity": 1}, {"id": 5, "quantity": 1}, {"id": 6, "quantity": 1}]	{}	{}	2025-06-13 14:38:56.384+05:30
28	3	Wedding	2025-06-25 00:00:00+05:30	Madurai	TBD	10:00	22:00	1200	elite	[{"id": 1, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}, {"id": 2, "quantity": 1}]	[{"id": 1, "quantity": 1}]	{}	{}	2025-06-14 11:45:06.975+05:30
32	4	Bridal Function	2025-06-14 12:06:26.791+05:30	Chennai	TBD	10:00	22:00	200	default	[{"id": 1, "quantity": 1}, {"id": 4, "quantity": 1}, {"id": 2, "quantity": 1}]	[{"id": 5, "quantity": 1}, {"id": 4, "quantity": 1}]	{}	{}	2025-06-14 12:39:00.538+05:30
33	5	Valima	2025-06-14 15:48:33.544+05:30	Chennai	TBD	10:00	22:00	200	default	[{"id": 1, "quantity": 1}]	[{"id": 6, "quantity": 1}]	{}	{}	2025-06-14 15:49:02.555+05:30
\.


--
-- Data for Name: quotation_predictions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quotation_predictions (id, quotation_id, success_probability, confidence_score, prediction_factors, model_version, predicted_at, actual_outcome, updated_at) FROM stdin;
\.


--
-- Data for Name: quotation_revisions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quotation_revisions (id, original_quotation_id, revision_number, revised_quotation_data, revision_reason, revised_by, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: quotation_workflow_history; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quotation_workflow_history (id, quotation_id, action, performed_at, comments, performed_by) FROM stdin;
\.


--
-- Data for Name: quotations; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quotations (id, lead_id, follow_up_id, quotation_number, client_name, bride_name, groom_name, mobile, whatsapp, alternate_mobile, alternate_whatsapp, email, default_package, total_amount, status, quotation_data, events_count, created_at, updated_at, slug, workflow_status, client_verbal_confirmation_date, payment_received_date, payment_amount, payment_reference, confirmation_required, created_by, revision_notes, client_feedback, negotiation_history, revision_count) FROM stdin;
3	5	\N	QT-2025-0002	Jothi Alagarsamy	Jothi	Alagarsamy	+91 9677362524	+91 9677362524	\N	\N	vikas@ooak.photography	basic	165000.00	rejected	{"email": "vikas@ooak.photography", "events": [{"id": "event-1", "end_time": "22:00", "event_date": "2025-06-24T18:30:00.000Z", "event_name": "Wedding", "start_time": "10:00", "venue_name": "TBD", "event_location": "Madurai", "expected_crowd": "1200", "selected_package": "elite", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}, {"id": 2, "quantity": 1}], "service_overrides": {}, "selected_deliverables": [{"id": 1, "quantity": 1}]}], "mobile": "9677362524", "whatsapp": "9677362524", "bride_name": "Jothi", "groom_name": "Alagarsamy", "client_name": "Jothi Alagarsamy", "custom_services": [], "default_package": "basic", "alternate_mobile": "", "package_overrides": {}, "selected_services": [], "service_overrides": {}, "alternate_whatsapp": "", "mobile_country_code": "+91", "selected_deliverables": [], "whatsapp_country_code": "+91", "alternate_mobile_country_code": "+91", "alternate_whatsapp_country_code": "+91"}	1	2025-06-14 06:04:40.575+05:30	2025-06-14 11:46:01.178+05:30	qt-2025-0002-iocnx3	rejected	\N	\N	\N	\N	t	22	\N	\N	[]	0
4	6	\N	QT-2025-0003	Pradeep	ramalakshmi	Sandeep	+91 9025303080	+91 9025303080	\N	\N	pradeep@gmail.com	basic	65000.00	approved	{"email": "pradeep@gmail.com", "events": [{"id": "event-1", "end_time": "22:00", "event_date": "2025-06-14T06:36:26.791Z", "event_name": "Bridal Function", "start_time": "10:00", "venue_name": "TBD", "event_location": "Chennai", "expected_crowd": "200", "selected_package": "default", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 4, "quantity": 1}, {"id": 2, "quantity": 1}], "service_overrides": {}, "selected_deliverables": [{"id": 5, "quantity": 1}, {"id": 4, "quantity": 1}]}], "mobile": "9025303080", "whatsapp": "9025303080", "bride_name": "ramalakshmi", "groom_name": "Sandeep", "client_name": "Pradeep", "custom_services": [], "default_package": "basic", "alternate_mobile": "", "package_overrides": {}, "selected_services": [], "service_overrides": {}, "alternate_whatsapp": "", "mobile_country_code": "+91", "selected_deliverables": [], "whatsapp_country_code": "+91", "alternate_mobile_country_code": "+91", "alternate_whatsapp_country_code": "+91"}	1	2025-06-14 12:07:02.035+05:30	2025-06-14 12:39:33.039+05:30	qt-2025-0003-1ofcqf	approved	\N	\N	\N	\N	t	6	\N	\N	[]	0
5	10	\N	QT-2025-0004	Abhi	Abhi	Ketan	+91 9677362524	+91 9677362524	\N	\N	navyavikas14@gmail.com	basic	30000.00	rejected	{"email": "navyavikas14@gmail.com", "events": [{"id": "event-1", "end_time": "22:00", "event_date": "2025-06-14T10:18:33.544Z", "event_name": "Valima", "start_time": "10:00", "venue_name": "TBD", "event_location": "Chennai", "expected_crowd": "200", "selected_package": "default", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}], "service_overrides": {}, "selected_deliverables": [{"id": 6, "quantity": 1}]}], "mobile": "9677362524", "whatsapp": "9677362524", "bride_name": "Abhi", "groom_name": "Ketan", "client_name": "Abhi", "custom_services": [], "default_package": "basic", "alternate_mobile": "", "package_overrides": {}, "selected_services": [], "service_overrides": {}, "alternate_whatsapp": "", "mobile_country_code": "+91", "selected_deliverables": [], "whatsapp_country_code": "+91", "alternate_mobile_country_code": "+91", "alternate_whatsapp_country_code": "+91"}	1	2025-06-14 15:49:02.55+05:30	2025-06-14 15:49:24.193+05:30	qt-2025-0004-gwa358	rejected	\N	\N	\N	\N	t	22	\N	\N	[]	0
1	2	\N	QT-2025-0001	Ramya	Ramya	Noble	+91 9677362524	+91 9677362524	\N	\N	ramya@example.com	elite	245000.00	approved	{"email": "ramya@example.com", "events": [{"id": "1", "end_time": "18:00", "event_date": "2025-06-24T18:30:00.000Z", "event_name": "Wedding", "start_time": "09:00", "venue_name": "Grand Palace", "event_location": "Chennai", "expected_crowd": "200-300", "selected_package": "elite", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}], "service_overrides": {}, "selected_deliverables": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 4, "quantity": 1}, {"id": 5, "quantity": 1}, {"id": 6, "quantity": 1}]}], "mobile": "9677362524", "whatsapp": "9677362524", "bride_name": "Ramya", "groom_name": "Noble", "client_name": "Ramya", "custom_services": [], "default_package": "elite", "alternate_mobile": "", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}], "service_overrides": {}, "alternate_whatsapp": "", "mobile_country_code": "+91", "selected_deliverables": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}], "whatsapp_country_code": "+91", "alternate_mobile_country_code": "+91", "alternate_whatsapp_country_code": "+91"}	1	2025-06-13 09:45:15.976+05:30	2025-06-19 13:34:08.447+05:30	qt-2025-0001-aw5xz2	approved	\N	\N	\N	\N	t	6	\N	\N	[]	0
\.


--
-- Data for Name: quotations_backup_before_migration; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quotations_backup_before_migration (id, lead_id, follow_up_id, quotation_number, client_name, bride_name, groom_name, mobile, whatsapp, alternate_mobile, alternate_whatsapp, email, default_package, total_amount, status, created_by, quotation_data, events_count, created_at, updated_at, slug, workflow_status, client_verbal_confirmation_date, payment_received_date, payment_amount, payment_reference, confirmation_required) FROM stdin;
1	2	\N	QT-2025-0001	Ramya	Ramya	Noble	+91 9677362524	+91 9677362524	\N	\N	ramya@example.com	elite	245000.00	rejected	00000000-0000-0000-0000-000000000022	{"email": "ramya@example.com", "events": [{"id": "1", "end_time": "18:00", "event_date": "2025-06-24T18:30:00.000Z", "event_name": "Wedding", "start_time": "09:00", "venue_name": "Grand Palace", "event_location": "Chennai", "expected_crowd": "200-300", "selected_package": "elite", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}], "service_overrides": {}, "selected_deliverables": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 4, "quantity": 1}, {"id": 5, "quantity": 1}, {"id": 6, "quantity": 1}]}], "mobile": "9677362524", "whatsapp": "9677362524", "bride_name": "Ramya", "groom_name": "Noble", "client_name": "Ramya", "custom_services": [], "default_package": "elite", "alternate_mobile": "", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}], "service_overrides": {}, "alternate_whatsapp": "", "mobile_country_code": "+91", "selected_deliverables": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}], "whatsapp_country_code": "+91", "alternate_mobile_country_code": "+91", "alternate_whatsapp_country_code": "+91"}	1	2025-06-13 09:45:15.976+05:30	2025-06-13 13:26:48.452+05:30	qt-2025-0001-aw5xz2	pending_approval	\N	\N	\N	\N	t
1	2	\N	QT-2025-0001	Ramya	Ramya	Noble	+91 9677362524	+91 9677362524	\N	\N	ramya@example.com	elite	245000.00	rejected	00000000-0000-0000-0000-000000000022	{"email": "ramya@example.com", "events": [{"id": "1", "end_time": "18:00", "event_date": "2025-06-24T18:30:00.000Z", "event_name": "Wedding", "start_time": "09:00", "venue_name": "Grand Palace", "event_location": "Chennai", "expected_crowd": "200-300", "selected_package": "elite", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}], "service_overrides": {}, "selected_deliverables": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 4, "quantity": 1}, {"id": 5, "quantity": 1}, {"id": 6, "quantity": 1}]}], "mobile": "9677362524", "whatsapp": "9677362524", "bride_name": "Ramya", "groom_name": "Noble", "client_name": "Ramya", "custom_services": [], "default_package": "elite", "alternate_mobile": "", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}], "service_overrides": {}, "alternate_whatsapp": "", "mobile_country_code": "+91", "selected_deliverables": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}], "whatsapp_country_code": "+91", "alternate_mobile_country_code": "+91", "alternate_whatsapp_country_code": "+91"}	1	2025-06-13 09:45:15.976+05:30	2025-06-13 13:26:48.452+05:30	qt-2025-0001-aw5xz2	pending_approval	\N	\N	\N	\N	t
1	2	\N	QT-2025-0001	Ramya	Ramya	Noble	+91 9677362524	+91 9677362524	\N	\N	ramya@example.com	elite	245000.00	rejected	00000000-0000-0000-0000-000000000022	{"email": "ramya@example.com", "events": [{"id": "1", "end_time": "18:00", "event_date": "2025-06-24T18:30:00.000Z", "event_name": "Wedding", "start_time": "09:00", "venue_name": "Grand Palace", "event_location": "Chennai", "expected_crowd": "200-300", "selected_package": "elite", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}], "service_overrides": {}, "selected_deliverables": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 4, "quantity": 1}, {"id": 5, "quantity": 1}, {"id": 6, "quantity": 1}]}], "mobile": "9677362524", "whatsapp": "9677362524", "bride_name": "Ramya", "groom_name": "Noble", "client_name": "Ramya", "custom_services": [], "default_package": "elite", "alternate_mobile": "", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}], "service_overrides": {}, "alternate_whatsapp": "", "mobile_country_code": "+91", "selected_deliverables": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}], "whatsapp_country_code": "+91", "alternate_mobile_country_code": "+91", "alternate_whatsapp_country_code": "+91"}	1	2025-06-13 09:45:15.976+05:30	2025-06-13 13:26:48.452+05:30	qt-2025-0001-aw5xz2	pending_approval	\N	\N	\N	\N	t
1	2	\N	QT-2025-0001	Ramya	Ramya	Noble	+91 9677362524	+91 9677362524	\N	\N	ramya@example.com	elite	245000.00	rejected	00000000-0000-0000-0000-000000000022	{"email": "ramya@example.com", "events": [{"id": "1", "end_time": "18:00", "event_date": "2025-06-24T18:30:00.000Z", "event_name": "Wedding", "start_time": "09:00", "venue_name": "Grand Palace", "event_location": "Chennai", "expected_crowd": "200-300", "selected_package": "elite", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}], "service_overrides": {}, "selected_deliverables": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 4, "quantity": 1}, {"id": 5, "quantity": 1}, {"id": 6, "quantity": 1}]}], "mobile": "9677362524", "whatsapp": "9677362524", "bride_name": "Ramya", "groom_name": "Noble", "client_name": "Ramya", "custom_services": [], "default_package": "elite", "alternate_mobile": "", "package_overrides": {}, "selected_services": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}, {"id": 3, "quantity": 1}, {"id": 4, "quantity": 1}], "service_overrides": {}, "alternate_whatsapp": "", "mobile_country_code": "+91", "selected_deliverables": [{"id": 1, "quantity": 1}, {"id": 2, "quantity": 1}], "whatsapp_country_code": "+91", "alternate_mobile_country_code": "+91", "alternate_whatsapp_country_code": "+91"}	1	2025-06-13 09:45:15.976+05:30	2025-06-13 13:26:48.452+05:30	qt-2025-0001-aw5xz2	pending_approval	\N	\N	\N	\N	t
\.


--
-- Data for Name: quote_components; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quote_components (id, quote_id, component_type, component_name, component_description, unit_price, quantity, subtotal, metadata, sort_order, created_at) FROM stdin;
\.


--
-- Data for Name: quote_deliverables_snapshot; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quote_deliverables_snapshot (id, quote_id, deliverable_id, deliverable_name, deliverable_type, process_name, package_type, tat, timing_type, sort_order, created_at) FROM stdin;
\.


--
-- Data for Name: quote_services_snapshot; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.quote_services_snapshot (id, quote_id, service_id, service_name, package_type, locked_price, quantity, subtotal, created_at) FROM stdin;
\.


--
-- Data for Name: revenue_forecasts; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.revenue_forecasts (id, forecast_period, period_start, period_end, predicted_revenue, confidence_interval_low, confidence_interval_high, contributing_factors, model_metrics, actual_revenue, forecast_accuracy, created_at) FROM stdin;
\.


--
-- Data for Name: role_menu_access; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.role_menu_access (id, role_name, menu_id, has_access, created_at, updated_at) FROM stdin;
1	Administrator	core-business	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
2	Administrator	dashboard	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
3	Administrator	ai-business-control	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
4	Administrator	sales-revenue	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
5	Administrator	sales-dashboard	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
6	Administrator	create-lead	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
7	Administrator	my-leads	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
8	Administrator	unassigned-leads	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
9	Administrator	follow-up	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
10	Administrator	quotations	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
11	Administrator	approval-queue	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
12	Administrator	rejected-quotes	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
13	Administrator	order-confirmation	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
14	Administrator	rejected-leads	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
15	Administrator	lead-sources	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
16	Administrator	ai-business-insights	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
17	Administrator	ai-call-analytics	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
18	Administrator	sales-head-analytics	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
19	Administrator	organization	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
20	Administrator	companies	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
21	Administrator	branches	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
22	Administrator	clients	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
23	Administrator	suppliers	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
24	Administrator	vendors	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
25	Administrator	roles-permissions	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
26	Administrator	user-accounts	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
27	Administrator	account-creation	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
28	Administrator	people-hr	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
29	Administrator	people-dashboard	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
30	Administrator	employees	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
31	Administrator	departments	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
32	Administrator	designations	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
33	Administrator	task-management	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
34	Administrator	my-tasks	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
35	Administrator	task-control-center	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
36	Administrator	ai-task-generator	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
37	Administrator	task-analytics	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
38	Administrator	task-calendar	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
39	Administrator	migration-panel	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
40	Administrator	task-reports	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
41	Administrator	task-sequence-management	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
42	Administrator	integration-status	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
43	Administrator	accounting-finance	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
44	Administrator	financial-dashboard	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
45	Administrator	invoices	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
46	Administrator	payments	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
47	Administrator	expenses	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
48	Administrator	event-coordination	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
49	Administrator	events-dashboard	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
50	Administrator	event-calendar	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
51	Administrator	events	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
52	Administrator	event-types	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
53	Administrator	services	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
54	Administrator	venues	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
55	Administrator	staff-assignment	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
56	Administrator	post-production	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
57	Administrator	production-dashboard	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
58	Administrator	deliverables	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
59	Administrator	deliverables-workflow	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
60	Administrator	projects	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
61	Administrator	workflow	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
62	Administrator	quality-control	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
63	Administrator	client-review	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
64	Administrator	final-delivery	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
65	Administrator	post-sales	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
66	Administrator	post-sales-dashboard	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
67	Administrator	delivery-management	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
68	Administrator	customer-support	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
69	Administrator	customer-feedback	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
70	Administrator	reports-analytics	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
71	Administrator	lead-source-analysis	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
72	Administrator	conversion-funnel	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
73	Administrator	team-performance	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
74	Administrator	business-trends	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
75	Administrator	custom-reports	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
76	Administrator	system-administration	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
77	Administrator	menu-manager	t	2025-06-11 05:47:09.464	2025-06-11 05:47:09.464
78	Manager	core-business	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
79	Manager	dashboard	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
80	Manager	ai-business-control	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
81	Manager	sales-revenue	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
82	Manager	sales-dashboard	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
83	Manager	create-lead	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
84	Manager	my-leads	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
85	Manager	unassigned-leads	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
86	Manager	follow-up	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
87	Manager	quotations	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
88	Manager	approval-queue	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
89	Manager	rejected-quotes	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
90	Manager	order-confirmation	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
91	Manager	rejected-leads	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
92	Manager	lead-sources	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
93	Manager	ai-business-insights	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
94	Manager	ai-call-analytics	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
95	Manager	sales-head-analytics	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
96	Manager	organization	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
97	Manager	companies	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
98	Manager	branches	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
99	Manager	clients	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
100	Manager	suppliers	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
101	Manager	vendors	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
102	Manager	roles-permissions	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
103	Manager	user-accounts	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
104	Manager	people-hr	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
105	Manager	people-dashboard	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
106	Manager	employees	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
107	Manager	departments	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
108	Manager	designations	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
109	Manager	task-management	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
110	Manager	my-tasks	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
111	Manager	task-control-center	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
112	Manager	ai-task-generator	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
113	Manager	task-analytics	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
114	Manager	task-calendar	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
115	Manager	migration-panel	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
116	Manager	task-reports	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
117	Manager	task-sequence-management	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
118	Manager	integration-status	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
119	Manager	accounting-finance	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
120	Manager	financial-dashboard	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
121	Manager	invoices	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
122	Manager	payments	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
123	Manager	expenses	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
124	Manager	event-coordination	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
125	Manager	events-dashboard	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
126	Manager	event-calendar	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
127	Manager	events	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
128	Manager	event-types	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
129	Manager	services	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
130	Manager	venues	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
131	Manager	staff-assignment	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
132	Manager	post-production	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
133	Manager	production-dashboard	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
134	Manager	deliverables	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
135	Manager	deliverables-workflow	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
136	Manager	projects	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
137	Manager	workflow	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
138	Manager	quality-control	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
139	Manager	client-review	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
140	Manager	final-delivery	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
141	Manager	post-sales	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
142	Manager	post-sales-dashboard	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
143	Manager	delivery-management	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
144	Manager	customer-support	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
145	Manager	customer-feedback	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
146	Manager	reports-analytics	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
147	Manager	lead-source-analysis	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
148	Manager	conversion-funnel	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
149	Manager	team-performance	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
150	Manager	business-trends	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
151	Manager	custom-reports	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
152	Sales Head	dashboard	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
153	Sales Head	sales-revenue	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
154	Sales Head	sales-dashboard	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
155	Sales Head	create-lead	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
156	Sales Head	my-leads	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
157	Sales Head	unassigned-leads	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
158	Sales Head	follow-up	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
159	Sales Head	quotations	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
160	Sales Head	approval-queue	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
161	Sales Head	rejected-quotes	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
162	Sales Head	order-confirmation	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
163	Sales Head	rejected-leads	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
164	Sales Head	lead-sources	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
165	Sales Head	ai-business-insights	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
166	Sales Head	ai-call-analytics	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
167	Sales Head	sales-head-analytics	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
168	Sales Head	people-hr	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
169	Sales Head	people-dashboard	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
170	Sales Head	employees	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
171	Sales Head	departments	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
172	Sales Head	designations	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
173	Sales Head	task-management	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
174	Sales Head	my-tasks	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
175	Sales Head	task-control-center	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
176	Sales Head	task-analytics	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
177	Sales Head	task-calendar	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
178	Sales Head	task-reports	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
179	Sales Head	reports-analytics	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
180	Sales Head	lead-source-analysis	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
181	Sales Head	conversion-funnel	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
182	Sales Head	team-performance	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
183	Sales Head	business-trends	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
184	Sales Head	custom-reports	t	2025-06-11 05:47:09.465	2025-06-11 05:47:09.465
185	Sales Executive	dashboard	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
186	Sales Executive	sales-revenue	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
187	Sales Executive	sales-dashboard	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
188	Sales Executive	create-lead	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
189	Sales Executive	my-leads	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
190	Sales Executive	follow-up	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
191	Sales Executive	quotations	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
192	Sales Executive	my-tasks	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
193	Sales Executive	task-calendar	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
194	Employee	dashboard	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
195	Employee	my-tasks	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
196	Employee	task-calendar	t	2025-06-11 05:47:09.466	2025-06-11 05:47:09.466
\.


--
-- Data for Name: role_menu_permissions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.role_menu_permissions (id, role_id, can_view, can_add, can_edit, can_delete, created_at, updated_at, created_by, updated_by, description, menu_string_id) FROM stdin;
9714	2	t	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 06:23:56.746+05:30	\N	\N	\N	sales-revenue
9718	2	t	t	t	f	2025-06-19 06:23:56.746+05:30	2025-06-19 06:23:56.746+05:30	\N	\N	\N	sales-follow-up
9719	2	t	t	t	f	2025-06-19 06:23:56.746+05:30	2025-06-19 06:23:56.746+05:30	\N	\N	\N	sales-quotations
9721	2	f	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 06:39:54.57+05:30	\N	\N	\N	people-dashboard
9720	2	f	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 06:40:30.419+05:30	\N	\N	\N	people-hr
9723	2	f	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 06:40:41.967+05:30	\N	\N	\N	reports-analytics
9725	2	f	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 06:40:44.829+05:30	\N	\N	\N	reports-team-performance
9724	2	f	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 06:40:46.802+05:30	\N	\N	\N	reports-lead-sources
9722	2	f	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 06:41:01.223+05:30	\N	\N	\N	people-employees
9712	2	f	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 08:44:02.784+05:30	\N	\N	\N	core-business
9713	2	f	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 08:44:03.777+05:30	\N	\N	\N	dashboard
9715	2	f	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 08:44:07.099+05:30	\N	\N	\N	sales-dashboard
9716	2	f	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 08:44:11.766+05:30	\N	\N	\N	sales-create-lead
9717	2	t	f	f	f	2025-06-19 06:23:56.746+05:30	2025-06-19 08:44:12.692+05:30	\N	\N	\N	sales-my-leads
9126	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	core-business
9127	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	dashboard
9519	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 06:42:09.868+05:30	\N	\N	\N	people-dashboard
9726	2	f	f	f	f	2025-06-19 07:10:46.927+05:30	2025-06-19 07:10:49.266+05:30	\N	\N	\N	event-coordination
9272	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	core-business
9273	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	dashboard
9493	7	t	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 08:41:39.816+05:30	\N	\N	\N	sales-order-confirmation
9345	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	core-business
9346	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	dashboard
9727	2	t	f	f	f	2025-06-19 08:44:17.06+05:30	2025-06-19 08:44:17.06+05:30	\N	\N	\N	sales-rejected-quotes
9128	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-order-confirmation
9129	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-rejected-leads
9130	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-lead-sources
9133	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-team-performance
9134	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations-analytics
9135	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-lead-sources
9136	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-conversion-funnel
9137	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization
9138	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-companies
9465	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-dashboard
9466	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-calendar
9467	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events
9468	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-types
9469	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-services
9470	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-venues
9471	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-staff
9472	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production
9473	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-dashboard
9139	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-branches
9140	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-clients
9141	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-suppliers
9142	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	ai-control
9143	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-revenue
9144	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-my-leads
9145	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-create-lead
9146	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-dashboard
9147	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-unassigned-leads
9148	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-follow-up
9149	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations
9150	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-user-accounts
9151	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-account-creation
9152	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-menu-manager
9153	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-hr
9154	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-dashboard
9155	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-employees
9156	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-departments
9157	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-designations
9158	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	task-management
9159	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-my-tasks
9160	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-control-center
9161	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-ai-generator
9162	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-analytics
9163	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-calendar
9164	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-reports
9165	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-sequence-management
9166	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-integration-status
9167	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-finance
9168	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-dashboard
9169	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-invoices
9170	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-payments
9171	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-expenses
9172	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	event-coordination
9173	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-dashboard
9174	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-calendar
9175	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events
9176	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-types
9177	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-services
9178	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-venues
9179	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-staff
9180	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production
9181	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-dashboard
9182	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables
9595	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-designations
9183	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables-workflow
9184	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-projects
9189	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales
9190	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-dashboard
9191	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-delivery
9192	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-support
9193	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-feedback
9194	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-analytics
9198	1	t	t	t	f	2025-06-18 10:50:34.26+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-trends
9494	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-rejected-leads
9499	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations-analytics
9501	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-conversion-funnel
9502	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization
9503	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-companies
9504	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-branches
9505	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-clients
9506	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-suppliers
9507	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	ai-control
9515	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-user-accounts
9516	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-account-creation
9517	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-menu-manager
9518	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-hr
9520	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-employees
9521	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-departments
9522	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-designations
9509	7	t	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 08:41:31.227+05:30	\N	\N	\N	sales-my-leads
9508	7	t	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 07:10:59.592+05:30	\N	\N	\N	sales-revenue
9513	7	t	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 06:42:40.821+05:30	\N	\N	\N	sales-follow-up
9495	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 06:42:47.242+05:30	\N	\N	\N	sales-lead-sources
9498	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 06:42:49.849+05:30	\N	\N	\N	reports-team-performance
9500	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 06:42:51.418+05:30	\N	\N	\N	reports-lead-sources
9510	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 08:41:29.579+05:30	\N	\N	\N	sales-create-lead
9492	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 06:43:54.12+05:30	\N	\N	\N	dashboard
9514	7	t	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 06:44:26.905+05:30	\N	\N	\N	sales-quotations
9491	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 08:41:15.96+05:30	\N	\N	\N	core-business
9511	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 08:41:24.366+05:30	\N	\N	\N	sales-dashboard
9512	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 08:41:35.139+05:30	\N	\N	\N	sales-unassigned-leads
9525	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-control-center
9526	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-ai-generator
9527	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-analytics
9528	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-calendar
9529	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-reports
9530	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-sequence-management
9531	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-integration-status
9532	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-finance
9533	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-dashboard
9534	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-invoices
9535	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-payments
9536	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-expenses
9537	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	event-coordination
9564	8	t	t	t	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	core-business
9565	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	dashboard
9566	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-order-confirmation
9567	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-rejected-leads
9568	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-lead-sources
9523	7	t	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 06:44:21.183+05:30	\N	\N	\N	task-management
9524	7	t	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 08:41:49.387+05:30	\N	\N	\N	tasks-my-tasks
9571	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-team-performance
9572	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations-analytics
9573	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-lead-sources
9574	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-conversion-funnel
9575	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization
9576	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-companies
9577	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-branches
9578	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-clients
9579	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-suppliers
9580	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	ai-control
9581	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-revenue
9582	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-my-leads
9583	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-create-lead
9584	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-dashboard
9585	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-unassigned-leads
9586	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-follow-up
9587	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations
9588	8	t	t	t	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-user-accounts
9589	8	t	t	t	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-account-creation
9590	8	t	t	t	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-menu-manager
9591	8	t	t	t	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-hr
9592	8	t	t	t	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-dashboard
9593	8	t	t	t	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-employees
9594	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-departments
9596	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	task-management
9597	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-my-tasks
9598	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-control-center
9599	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-ai-generator
9600	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-analytics
9601	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-calendar
9602	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-reports
9603	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-sequence-management
9604	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-integration-status
9605	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-finance
9606	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-dashboard
9607	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-invoices
9608	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-payments
9609	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-expenses
9610	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	event-coordination
9274	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-order-confirmation
9275	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-rejected-leads
9276	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-lead-sources
9279	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-team-performance
9280	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations-analytics
9281	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-lead-sources
9282	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-conversion-funnel
9283	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization
9284	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-companies
9285	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-branches
9286	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-clients
9287	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-suppliers
9288	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	ai-control
9289	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-revenue
9290	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-my-leads
9291	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-create-lead
9292	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-dashboard
9293	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-unassigned-leads
9294	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-follow-up
9295	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations
9296	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-user-accounts
9297	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-account-creation
9298	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-menu-manager
9299	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-hr
9300	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-dashboard
9301	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-employees
9302	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-departments
9303	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-designations
9304	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	task-management
9305	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-my-tasks
9306	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-control-center
9307	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-ai-generator
9308	3	f	f	f	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-analytics
9309	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-calendar
9310	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-reports
9311	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-sequence-management
9312	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-integration-status
9313	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-finance
9314	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-dashboard
9315	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-invoices
9316	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-payments
9317	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-expenses
9318	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	event-coordination
9319	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-dashboard
9320	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-calendar
9321	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events
9322	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-types
9323	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-services
9324	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-venues
9325	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-staff
9326	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production
9327	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-dashboard
9328	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables
9329	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables-workflow
9330	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-projects
9335	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales
9336	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-dashboard
9337	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-delivery
9338	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-support
9339	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-feedback
9340	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-analytics
9344	3	t	t	t	f	2025-06-18 10:50:34.274+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-trends
9637	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	core-business
9638	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	dashboard
9639	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-order-confirmation
9640	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-rejected-leads
9641	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-lead-sources
9644	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-team-performance
9645	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations-analytics
9646	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-lead-sources
9647	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-conversion-funnel
9648	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization
9649	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-companies
9650	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-branches
9651	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-clients
9652	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-suppliers
9653	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	ai-control
9654	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-revenue
9655	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-my-leads
9656	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-create-lead
9657	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-dashboard
9658	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-unassigned-leads
9659	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-follow-up
9660	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations
9661	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-user-accounts
9662	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-account-creation
9663	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-menu-manager
9664	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-hr
9665	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-dashboard
9666	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-employees
9667	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-departments
9668	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-designations
9669	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	task-management
9670	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-my-tasks
9671	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-control-center
9672	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-ai-generator
9673	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-analytics
9674	9	t	t	t	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-calendar
9675	9	t	t	t	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-reports
9676	9	t	t	t	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-sequence-management
9677	9	t	t	t	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-integration-status
9678	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-finance
9679	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-dashboard
9680	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-invoices
9681	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-payments
9682	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-expenses
9683	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	event-coordination
9347	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-order-confirmation
9348	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-rejected-leads
9349	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-lead-sources
9352	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-team-performance
9353	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations-analytics
9354	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-lead-sources
9355	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-conversion-funnel
9356	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization
9357	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-companies
9358	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-branches
9359	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-clients
9360	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-suppliers
9361	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	ai-control
9362	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-revenue
9363	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-my-leads
9364	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-create-lead
9365	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-dashboard
9366	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-unassigned-leads
9367	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-follow-up
9368	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations
9369	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-user-accounts
9370	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-account-creation
9371	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-menu-manager
9372	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-hr
9373	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-dashboard
9374	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-employees
9375	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-departments
9376	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-designations
9377	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	task-management
9378	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-my-tasks
9379	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-control-center
9380	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-ai-generator
9381	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-analytics
9382	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-calendar
9383	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-reports
9384	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-sequence-management
9385	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-integration-status
9386	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-finance
9387	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-dashboard
9388	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-invoices
9389	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-payments
9390	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-expenses
9391	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	event-coordination
9392	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-dashboard
9393	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-calendar
9394	4	t	t	t	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events
9395	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-types
9396	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-services
9397	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-venues
9398	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-staff
9399	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production
9400	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-dashboard
9401	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables
9402	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables-workflow
9403	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-projects
9408	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales
9409	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-dashboard
9410	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-delivery
9411	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-support
9412	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-feedback
9413	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-analytics
9417	4	f	f	f	f	2025-06-18 10:50:34.281+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-trends
9418	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	core-business
9419	5	t	t	t	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	dashboard
9420	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-order-confirmation
9421	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-rejected-leads
9422	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-lead-sources
9425	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-team-performance
9426	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations-analytics
9427	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-lead-sources
9428	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-conversion-funnel
9429	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization
9430	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-companies
9431	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-branches
9432	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-clients
9433	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-suppliers
9434	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	ai-control
9435	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-revenue
9436	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-my-leads
9437	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-create-lead
9438	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-dashboard
9439	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-unassigned-leads
9440	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-follow-up
9441	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	sales-quotations
9442	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-user-accounts
9443	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-account-creation
9444	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	organization-menu-manager
9445	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-hr
9446	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-dashboard
9447	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-employees
9448	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-departments
9449	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	people-designations
9450	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	task-management
9451	5	t	t	t	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-my-tasks
9452	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-control-center
9453	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-ai-generator
9454	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-analytics
9455	5	t	t	t	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-calendar
9456	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-reports
9457	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-sequence-management
9458	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	tasks-integration-status
9459	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-finance
9460	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-dashboard
9461	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-invoices
9462	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-payments
9463	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	accounting-expenses
9464	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	event-coordination
9474	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables
9475	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables-workflow
9476	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-projects
9481	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales
9482	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-dashboard
9483	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-delivery
9484	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-support
9485	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-feedback
9486	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-analytics
9490	5	f	f	f	f	2025-06-18 10:50:34.288+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-trends
9538	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-dashboard
9539	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-calendar
9540	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events
9541	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-types
9542	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-services
9543	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-venues
9544	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-staff
9545	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production
9546	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-dashboard
9547	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables
9548	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables-workflow
9549	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-projects
9555	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-dashboard
9556	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-delivery
9557	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-support
9558	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-feedback
9559	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-analytics
9563	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-trends
9611	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-dashboard
9612	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-calendar
9613	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events
9614	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-types
9615	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-services
9616	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-venues
9617	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-staff
9618	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production
9619	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-dashboard
9620	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables
9621	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables-workflow
9622	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-projects
9627	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales
9628	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-dashboard
9629	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-delivery
9630	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-support
9631	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-feedback
9632	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-analytics
9636	8	f	f	f	f	2025-06-18 10:50:34.3+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-trends
9684	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-dashboard
9685	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-calendar
9686	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events
9687	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-types
9688	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-services
9689	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-venues
9690	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	events-staff
9691	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production
9692	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-dashboard
9693	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables
9694	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-deliverables-workflow
9695	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-production-projects
9700	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales
9701	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-dashboard
9702	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-delivery
9703	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-support
9704	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	post-sales-feedback
9705	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-analytics
9709	9	f	f	f	f	2025-06-18 10:50:34.306+05:30	2025-06-18 17:33:20.602+05:30	\N	\N	\N	reports-trends
9728	2	t	f	f	f	2025-06-19 08:44:55.06+05:30	2025-06-19 08:44:55.06+05:30	\N	\N	\N	task-management
9554	7	f	f	f	f	2025-06-18 10:50:34.294+05:30	2025-06-19 08:42:55.724+05:30	\N	\N	\N	post-sales
9729	2	t	f	f	f	2025-06-19 08:44:56.29+05:30	2025-06-19 08:44:56.29+05:30	\N	\N	\N	tasks-my-tasks
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.role_permissions (id, role_id, permission_id, created_at, updated_at, status) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.roles (id, title, description, department_id, responsibilities, required_skills, is_management, created_at, updated_at, is_system_role, is_admin, name, permissions) FROM stdin;
2	Sales Executive	Sales team member with limited access	\N	\N	\N	f	2025-06-11 16:49:38.368+05:30	2025-06-11 16:49:38.368+05:30	t	f	Sales Executive	{}
3	Manager	Department manager with elevated permissions	\N	\N	\N	f	2025-06-11 16:49:38.368+05:30	2025-06-11 16:49:38.368+05:30	t	f	Manager	{}
4	Sales Head	Sales department head	\N	\N	\N	f	2025-06-11 16:49:38.368+05:30	2025-06-11 16:49:38.368+05:30	t	f	Sales Head	{}
5	Employee	Regular employee with basic access	\N	\N	\N	f	2025-06-11 16:49:38.368+05:30	2025-06-11 16:49:38.368+05:30	t	f	Employee	{}
7	Sales Manager	Sales Manager	\N	\N	\N	f	2025-06-13 05:38:49.819+05:30	2025-06-13 07:31:33.514+05:30	f	f	Sales Manager	{"core": {"edit": false, "view": false, "delete": false}, "sales": {"edit": false, "view": false, "delete": false}, "tasks": {"edit": false, "view": false, "delete": false}, "events": {"edit": false, "view": false, "delete": false}, "people": {"edit": false, "view": false, "delete": false}, "system": {"edit": false, "view": false, "delete": false}, "reports": {"edit": false, "view": false, "delete": false}, "dashboard": {"edit": false, "view": false, "delete": false}, "accounting": {"edit": false, "view": false, "delete": false}, "ai-control": {"edit": false, "view": false, "delete": false}, "post-sales": {"edit": false, "view": false, "delete": false}, "events-list": {"edit": false, "view": false, "delete": false}, "tasks-admin": {"edit": false, "view": false, "delete": false}, "events-staff": {"edit": false, "view": false, "delete": false}, "events-types": {"edit": false, "view": false, "delete": false}, "organization": {"edit": false, "view": false, "delete": false}, "events-venues": {"edit": false, "view": false, "delete": false}, "tasks-reports": {"edit": false, "view": false, "delete": false}, "reports-custom": {"edit": false, "view": false, "delete": false}, "reports-trends": {"edit": false, "view": false, "delete": false}, "sales-my-leads": {"edit": false, "view": false, "delete": false}, "tasks-calendar": {"edit": false, "view": false, "delete": false}, "admin-dashboard": {"edit": false, "view": false, "delete": false}, "events-calendar": {"edit": false, "view": false, "delete": false}, "events-services": {"edit": false, "view": false, "delete": false}, "post-production": {"edit": false, "view": false, "delete": false}, "sales-approvals": {"edit": false, "view": false, "delete": false}, "sales-dashboard": {"edit": false, "view": false, "delete": false}, "sales-follow-up": {"edit": false, "view": false, "delete": false}, "tasks-analytics": {"edit": false, "view": false, "delete": false}, "tasks-dashboard": {"edit": false, "view": false, "delete": false}, "tasks-migration": {"edit": false, "view": false, "delete": false}, "tasks-sequences": {"edit": false, "view": false, "delete": false}, "admin-menu-debug": {"edit": false, "view": false, "delete": false}, "events-dashboard": {"edit": false, "view": false, "delete": false}, "people-dashboard": {"edit": false, "view": false, "delete": false}, "people-employees": {"edit": false, "view": false, "delete": false}, "sales-quotations": {"edit": false, "view": false, "delete": false}, "admin-menu-repair": {"edit": false, "view": false, "delete": false}, "sales-ai-insights": {"edit": false, "view": false, "delete": false}, "sales-create-lead": {"edit": false, "view": false, "delete": false}, "admin-test-feature": {"edit": false, "view": false, "delete": false}, "organization-roles": {"edit": false, "view": false, "delete": false}, "people-departments": {"edit": false, "view": false, "delete": false}, "post-sales-support": {"edit": false, "view": false, "delete": false}, "sales-lead-sources": {"edit": false, "view": false, "delete": false}, "tasks-ai-generator": {"edit": false, "view": false, "delete": false}, "accounting-expenses": {"edit": false, "view": false, "delete": false}, "accounting-invoices": {"edit": false, "view": false, "delete": false}, "accounting-payments": {"edit": false, "view": false, "delete": false}, "people-designations": {"edit": false, "view": false, "delete": false}, "post-sales-delivery": {"edit": false, "view": false, "delete": false}, "post-sales-feedback": {"edit": false, "view": false, "delete": false}, "accounting-dashboard": {"edit": false, "view": false, "delete": false}, "organization-clients": {"edit": false, "view": false, "delete": false}, "organization-vendors": {"edit": false, "view": false, "delete": false}, "post-sales-dashboard": {"edit": false, "view": false, "delete": false}, "reports-lead-sources": {"edit": false, "view": false, "delete": false}, "sales-call-analytics": {"edit": false, "view": false, "delete": false}, "sales-head-analytics": {"edit": false, "view": false, "delete": false}, "sales-rejected-leads": {"edit": false, "view": false, "delete": false}, "sales-rejected-quote": {"edit": false, "view": false, "delete": false}, "admin-system-settings": {"edit": false, "view": false, "delete": false}, "organization-branches": {"edit": false, "view": false, "delete": false}, "admin-database-monitor": {"edit": false, "view": false, "delete": false}, "admin-menu-permissions": {"edit": false, "view": false, "delete": false}, "admin-test-permissions": {"edit": false, "view": false, "delete": false}, "organization-companies": {"edit": false, "view": false, "delete": false}, "organization-suppliers": {"edit": false, "view": false, "delete": false}, "post-production-review": {"edit": false, "view": false, "delete": false}, "sales-unassigned-leads": {"edit": false, "view": false, "delete": false}, "post-production-quality": {"edit": false, "view": false, "delete": false}, "post-production-delivery": {"edit": false, "view": false, "delete": false}, "post-production-projects": {"edit": false, "view": false, "delete": false}, "post-production-workflow": {"edit": false, "view": false, "delete": false}, "reports-team-performance": {"edit": false, "view": false, "delete": false}, "sales-order-confirmation": {"edit": false, "view": false, "delete": false}, "post-production-dashboard": {"edit": false, "view": false, "delete": false}, "reports-conversion-funnel": {"edit": false, "view": false, "delete": false}, "organization-user-accounts": {"edit": false, "view": false, "delete": false}, "tasks-sequences-integration": {"edit": false, "view": false, "delete": false}, "post-production-deliverables": {"edit": false, "view": false, "delete": false}, "organization-account-creation": {"edit": false, "view": false, "delete": false}, "post-production-deliverables-workflow": {"edit": false, "view": false, "delete": false}}
8	Admin Head	Admin Head	\N	\N	\N	f	2025-06-13 07:27:51.44+05:30	2025-06-13 07:31:38.261+05:30	f	f	Admin Head	{"core": {"edit": false, "view": false, "delete": false}, "sales": {"edit": false, "view": false, "delete": false}, "tasks": {"edit": false, "view": false, "delete": false}, "events": {"edit": false, "view": false, "delete": false}, "people": {"edit": false, "view": false, "delete": false}, "system": {"edit": false, "view": false, "delete": false}, "reports": {"edit": false, "view": false, "delete": false}, "dashboard": {"edit": false, "view": false, "delete": false}, "accounting": {"edit": false, "view": false, "delete": false}, "ai-control": {"edit": false, "view": false, "delete": false}, "post-sales": {"edit": false, "view": false, "delete": false}, "events-list": {"edit": false, "view": false, "delete": false}, "tasks-admin": {"edit": false, "view": false, "delete": false}, "events-staff": {"edit": false, "view": false, "delete": false}, "events-types": {"edit": false, "view": false, "delete": false}, "organization": {"edit": false, "view": false, "delete": false}, "events-venues": {"edit": false, "view": false, "delete": false}, "tasks-reports": {"edit": false, "view": false, "delete": false}, "reports-custom": {"edit": false, "view": false, "delete": false}, "reports-trends": {"edit": false, "view": false, "delete": false}, "sales-my-leads": {"edit": false, "view": false, "delete": false}, "tasks-calendar": {"edit": false, "view": false, "delete": false}, "admin-dashboard": {"edit": false, "view": false, "delete": false}, "events-calendar": {"edit": false, "view": false, "delete": false}, "events-services": {"edit": false, "view": false, "delete": false}, "post-production": {"edit": false, "view": false, "delete": false}, "sales-approvals": {"edit": false, "view": false, "delete": false}, "sales-dashboard": {"edit": false, "view": false, "delete": false}, "sales-follow-up": {"edit": false, "view": false, "delete": false}, "tasks-analytics": {"edit": false, "view": false, "delete": false}, "tasks-dashboard": {"edit": false, "view": false, "delete": false}, "tasks-migration": {"edit": false, "view": false, "delete": false}, "tasks-sequences": {"edit": false, "view": false, "delete": false}, "admin-menu-debug": {"edit": false, "view": false, "delete": false}, "events-dashboard": {"edit": false, "view": false, "delete": false}, "people-dashboard": {"edit": false, "view": false, "delete": false}, "people-employees": {"edit": false, "view": false, "delete": false}, "sales-quotations": {"edit": false, "view": false, "delete": false}, "admin-menu-repair": {"edit": false, "view": false, "delete": false}, "sales-ai-insights": {"edit": false, "view": false, "delete": false}, "sales-create-lead": {"edit": false, "view": false, "delete": false}, "admin-test-feature": {"edit": false, "view": false, "delete": false}, "organization-roles": {"edit": false, "view": false, "delete": false}, "people-departments": {"edit": false, "view": false, "delete": false}, "post-sales-support": {"edit": false, "view": false, "delete": false}, "sales-lead-sources": {"edit": false, "view": false, "delete": false}, "tasks-ai-generator": {"edit": false, "view": false, "delete": false}, "accounting-expenses": {"edit": false, "view": false, "delete": false}, "accounting-invoices": {"edit": false, "view": false, "delete": false}, "accounting-payments": {"edit": false, "view": false, "delete": false}, "people-designations": {"edit": false, "view": false, "delete": false}, "post-sales-delivery": {"edit": false, "view": false, "delete": false}, "post-sales-feedback": {"edit": false, "view": false, "delete": false}, "accounting-dashboard": {"edit": false, "view": false, "delete": false}, "organization-clients": {"edit": false, "view": false, "delete": false}, "organization-vendors": {"edit": false, "view": false, "delete": false}, "post-sales-dashboard": {"edit": false, "view": false, "delete": false}, "reports-lead-sources": {"edit": false, "view": false, "delete": false}, "sales-call-analytics": {"edit": false, "view": false, "delete": false}, "sales-head-analytics": {"edit": false, "view": false, "delete": false}, "sales-rejected-leads": {"edit": false, "view": false, "delete": false}, "sales-rejected-quote": {"edit": false, "view": false, "delete": false}, "admin-system-settings": {"edit": false, "view": false, "delete": false}, "organization-branches": {"edit": false, "view": false, "delete": false}, "admin-database-monitor": {"edit": false, "view": false, "delete": false}, "admin-menu-permissions": {"edit": false, "view": false, "delete": false}, "admin-test-permissions": {"edit": false, "view": false, "delete": false}, "organization-companies": {"edit": false, "view": false, "delete": false}, "organization-suppliers": {"edit": false, "view": false, "delete": false}, "post-production-review": {"edit": false, "view": false, "delete": false}, "sales-unassigned-leads": {"edit": false, "view": false, "delete": false}, "post-production-quality": {"edit": false, "view": false, "delete": false}, "post-production-delivery": {"edit": false, "view": false, "delete": false}, "post-production-projects": {"edit": false, "view": false, "delete": false}, "post-production-workflow": {"edit": false, "view": false, "delete": false}, "reports-team-performance": {"edit": false, "view": false, "delete": false}, "sales-order-confirmation": {"edit": false, "view": false, "delete": false}, "post-production-dashboard": {"edit": false, "view": false, "delete": false}, "reports-conversion-funnel": {"edit": false, "view": false, "delete": false}, "organization-user-accounts": {"edit": false, "view": false, "delete": false}, "tasks-sequences-integration": {"edit": false, "view": false, "delete": false}, "post-production-deliverables": {"edit": false, "view": false, "delete": false}, "organization-account-creation": {"edit": false, "view": false, "delete": false}, "post-production-deliverables-workflow": {"edit": false, "view": false, "delete": false}}
1	Administrator	Full system access	\N	\N	\N	f	2025-06-11 16:49:38.368+05:30	2025-06-18 22:38:12.032+05:30	t	t	Administrator	["*"]
\.


--
-- Data for Name: sales_activities; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.sales_activities (id, employee_id, quotation_id, activity_type, activity_description, activity_outcome, time_spent_minutes, activity_date, notes, client_name, deal_value, created_at) FROM stdin;
\.


--
-- Data for Name: sales_performance_metrics; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.sales_performance_metrics (id, employee_id, metric_period, quotations_created, quotations_converted, total_revenue_generated, avg_deal_size, avg_conversion_time_days, follow_ups_completed, client_meetings_held, calls_made, emails_sent, conversion_rate, activity_score, performance_score, created_at) FROM stdin;
\.


--
-- Data for Name: sales_team_members; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.sales_team_members (id, employee_id, full_name, email, phone, role, hire_date, territory, target_monthly, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sequence_rules; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.sequence_rules (id, sequence_template_id, rule_type, condition_field, condition_operator, condition_value, action_type, action_data, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: sequence_steps; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.sequence_steps (id, sequence_template_id, step_number, title, description, icon, due_after_hours, priority, is_conditional, condition_type, condition_value, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: service_packages; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.service_packages (id, package_name, package_display_name, description, is_active, sort_order, created_at) FROM stdin;
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.services (id, servicename, status, description, category, price, unit, created_at, updated_at, basic_price, premium_price, elite_price, package_included) FROM stdin;
1	CANDID PHOTOGRAPHY	Active	CANDID PHOTOGRAPHY	Photography	30000.00	1	2025-06-13 09:18:10.219+05:30	2025-06-13 09:18:10.224+05:30	20000.00	30000.00	50000.00	{"basic": true, "elite": true, "premium": true}
2	CANDID VIDEOGRAPHY	Active	CANDID VIDEOGRAPHY	Videography	30000.00	1	2025-06-13 09:18:45.723+05:30	2025-06-13 09:18:45.723+05:30	20000.00	30000.00	50000.00	{"basic": true, "elite": true, "premium": true}
3	CONVENTIONAL PHOTOGRAPHY	Active	TRADITIONAL PHOTOGRAPHY	Photography	12500.00	1	2025-06-13 09:19:23.932+05:30	2025-06-14 14:22:03.654+05:30	10000.00	15000.00	20000.00	{"basic": true, "elite": true, "premium": true}
4	CONVENTIONAL VIDEOGRAPHY	Active	TRADITIONAL VIDEOGRAPHY	Videography	12500.00	1	2025-06-13 09:19:53.724+05:30	2025-06-14 14:22:26.562+05:30	10000.00	15000.00	20000.00	{"basic": true, "elite": true, "premium": true}
6	4K - CONVENTIONAL VIDEOGRAPHY	Active	4K - CONVENTIONAL VIDEOGRAPHY	Videography	\N	\N	2025-06-14 14:21:43.632+05:30	2025-06-14 14:22:39.641+05:30	20000.00	25000.00	30000.00	{"basic": true, "elite": true, "premium": true}
5	4K - CANDID CINEMATOGRAPHY	Active	4K - CANDID CINEMATOGRAPHY	Videography	\N	\N	2025-06-14 14:20:30.246+05:30	2025-06-14 14:22:48.666+05:30	40000.00	50000.00	60000.00	{"basic": true, "elite": true, "premium": true}
7	AI POWERED GALLERY - FACE SCAN	Active	AI POWERED GALLERY - FACE SCAN	Other	\N	\N	2025-06-17 10:52:21.592+05:30	2025-06-17 10:52:21.597+05:30	10000.00	15000.00	20000.00	{"basic": true, "elite": true, "premium": true}
8	LED TV - 49 INCH	Active	LED TV - 49 INCH	Other	\N	\N	2025-06-17 10:56:00.531+05:30	2025-06-17 10:56:00.537+05:30	3000.00	3500.00	4000.00	{"basic": true, "elite": true, "premium": true}
9	LED WALL - 12 FT X 8 FT	Active	LED WALL - 12 FT X 8 FT	Other	\N	\N	2025-06-17 11:18:20.032+05:30	2025-06-17 11:18:20.037+05:30	20000.00	25000.00	30000.00	{"basic": true, "elite": true, "premium": true}
10	360 DEGREE SPIN VIDEO	Active	360 DEGREE SPIN VIDEO	Other	\N	\N	2025-06-17 11:18:54.626+05:30	2025-06-17 11:18:54.632+05:30	25000.00	30000.00	35000.00	{"basic": true, "elite": true, "premium": true}
11	MIXING UNIT	Active	MIXING UNIT	Other	\N	\N	2025-06-17 11:19:26.979+05:30	2025-06-17 11:19:26.985+05:30	15000.00	20000.00	25000.00	{"basic": true, "elite": true, "premium": true}
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.suppliers (id, supplier_code, name, contact_person, email, phone, address, city, state, postal_code, country, category, tax_id, payment_terms, website, notes, status, created_at, updated_at, lead_time) FROM stdin;
\.


--
-- Data for Name: system_logs; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.system_logs (id, action, details, created_at) FROM stdin;
\.


--
-- Data for Name: task_generation_log; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.task_generation_log (id, lead_id, quotation_id, rule_triggered, task_id, success, error_message, triggered_by, triggered_at, metadata) FROM stdin;
\.


--
-- Data for Name: task_performance_metrics; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.task_performance_metrics (id, task_id, lead_id, quotation_id, assigned_to, created_date, due_date, completed_date, days_to_complete, hours_estimated, hours_actual, efficiency_ratio, priority_level, was_overdue, quality_rating, revenue_impact, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: task_sequence_templates; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.task_sequence_templates (id, name, description, category, is_active, created_by, metadata, created_at, updated_at) FROM stdin;
1	Standard Photography Follow-up	Default follow-up sequence for photography quotations	sales_followup	t	Admin	{"total_steps": 5, "success_rate": 0.65, "estimated_duration_days": 7}	2025-06-19 10:30:44.079+05:30	2025-06-19 10:30:44.079+05:30
2	High-Value Client Sequence	Premium follow-up for quotations above ₹1,00,000	premium_followup	t	Admin	{"total_steps": 5, "success_rate": 0.85, "value_threshold": 100000, "estimated_duration_days": 5}	2025-06-19 10:30:44.079+05:30	2025-06-19 10:30:44.079+05:30
3	Standard Photography Follow-up	Default follow-up sequence for photography quotations	sales_followup	t	Admin	{"total_steps": 5, "success_rate": 0.65, "estimated_duration_days": 7}	2025-06-19 10:30:51.239+05:30	2025-06-19 10:30:51.239+05:30
4	High-Value Client Sequence	Premium follow-up for quotations above ₹1,00,000	premium_followup	t	Admin	{"total_steps": 5, "success_rate": 0.85, "value_threshold": 100000, "estimated_duration_days": 5}	2025-06-19 10:30:51.239+05:30	2025-06-19 10:30:51.239+05:30
\.


--
-- Data for Name: task_status_history; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.task_status_history (id, task_id, from_status, to_status, changed_at, changed_by, notes, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: team_members; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.team_members (team_id, employee_id, joined_at) FROM stdin;
\.


--
-- Data for Name: team_performance_trends; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.team_performance_trends (id, period_start, period_end, total_quotations, total_conversions, total_revenue, team_conversion_rate, avg_deal_size, avg_sales_cycle_days, top_performer_id, underperformer_id, performance_variance, team_activity_score, coaching_opportunities, process_improvements_needed, created_at) FROM stdin;
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.teams (id, name, description, department_id, team_lead_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: unified_role_permissions; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.unified_role_permissions (id, role_id, menu_string_id, can_view, can_add, can_edit, can_delete, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_accounts; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.user_accounts (id, employee_id, role_id, username, email, password_hash, is_active, last_login, created_at, updated_at) FROM stdin;
2	2	2	pradeep	pradeep@company.com	$2b$10$sEIIqddCmP8fP3vEy14mWODe6mXQ2ZZIp.NmaCBYJf8n2k2VqLRZ6	t	2025-06-12 18:28:28.011	2025-06-11 16:49:38.374+05:30	2025-06-11 16:52:20.318+05:30
7	3	8	manager	manager@company.com	$2b$10$gndW3GzDQxbxp0oxywLCLuKU0sWxhm13xL7XQlnnwZKgUVaYDlaCu	t	2025-06-12 22:36:54.731	2025-06-13 07:29:27.075+05:30	2025-06-13 07:29:27.075+05:30
6	7	4	durga.ooak	durga.ooak@gmail.com	$2b$10$sNCoweGwVk3FoGgkQ586xuOtsTAKPT8B.6oIXjg8AZ51fL1pjomT2	t	2025-06-17 03:26:54.361	2025-06-13 05:44:52.558+05:30	2025-06-13 05:44:52.558+05:30
4	22	2	deepikadevimurali	deepikadevimurali@gmail.com	$2b$10$kjr9dM.VW2D5iDvjvJhQ5uNVCe.gqsBtHyJUb4btBJxHt5G6Fno9u	t	2025-06-18 04:50:12.023	2025-06-13 05:37:46.785+05:30	2025-06-13 05:37:46.786+05:30
5	6	7	rasvickys	rasvickys@gmail.com	$2b$10$ImJWD9X9a2Iphl9BulmR4uP2fMoZc7QMfO7YtwWLB70X38vQeX2Cu	t	2025-06-18 04:50:37.398	2025-06-13 05:39:19.941+05:30	2025-06-13 05:39:19.941+05:30
1	1	1	admin	admin@company.com	$2b$10$sEIIqddCmP8fP3vEy14mWODe6mXQ2ZZIp.NmaCBYJf8n2k2VqLRZ6	t	2025-06-18 05:01:59.123	2025-06-11 16:49:38.374+05:30	2025-06-11 16:52:20.318+05:30
8	9	4	feroz.munna@yahoo.com	feroz.munna@yahoo.com	$2b$12$0sa0SWh2SDDqZTQ9c3upu.jOT6FWnYoOYxYw7M6EUvPAAew/bQGP6	t	\N	2025-06-19 07:03:06.445+05:30	2025-06-19 07:03:06.445+05:30
\.


--
-- Data for Name: user_activity_history; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.user_activity_history (id, user_id, activity_type, activity_data, session_id, ip_address, user_agent, created_at) FROM stdin;
\.


--
-- Data for Name: user_ai_profiles; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.user_ai_profiles (id, user_id, personality_type, communication_style, preferred_content_length, engagement_patterns, response_time_patterns, content_preferences, ai_learning_enabled, personalization_score, last_interaction, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_behavior_analytics; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.user_behavior_analytics (id, user_id, most_active_hours, avg_response_time, preferred_notification_types, engagement_score, timezone, device_types, last_activity, total_notifications_received, total_notifications_read, average_read_time, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_engagement_analytics; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.user_engagement_analytics (id, user_id, notification_id, engagement_type, engagement_value, channel, device_type, time_to_engage, context_data, created_at) FROM stdin;
\.


--
-- Data for Name: user_id_mapping; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.user_id_mapping (numeric_id, uuid, created_at) FROM stdin;
\.


--
-- Data for Name: user_preferences; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.user_preferences (id, user_id, name, include_name, channel_preferences, quiet_hours_start, quiet_hours_end, frequency_limit, ai_optimization_enabled, personalization_level, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.user_roles (id, name, description, permissions, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.users (id, username, password, email, created_at, updated_at, employee_id) FROM stdin;
\.


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.vendors (id, vendor_code, name, contact_person, email, phone, address, city, state, postal_code, country, category, tax_id, payment_terms, website, notes, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: whatsapp_config; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.whatsapp_config (id, business_phone_number_id, access_token, webhook_verify_token, webhook_url, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: whatsapp_messages; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.whatsapp_messages (id, quotation_id, client_phone, message_text, message_type, "timestamp", interakt_message_id, media_url, media_type, ai_analyzed, created_at, updated_at) FROM stdin;
3	\N	918888888888	Testing AI protection system	incoming	2025-01-29 04:30:00	test_protection	\N	\N	f	2025-06-13 04:47:22.911	2025-06-13 04:47:22.911
5	\N	919884261872	Please find the chnages based on this versions.. \nAlso we have included missing points which are not completed from the old one as well.\n\nOld change\n7. Thozhan taking groom on stage while holding groom's hand.\n19/05 - in new video timing changed, need to add before 4:33\n09/06 - in new video, need to add before 4:34\n\nNew video changes\n1. Pls add the thamboolam bags table and urli with flower kolam clip after 3:54 (this was available in previous edited video but missing in this new version)\n\n2. Bride father blessing thaali plate clip is missing..pls add before 6:27...\n\n3. 26:00 to 26:18 should come after 25:42 \n    25:43 to 25:58 should come after above one.\n(Bride & groom getting blessing from grooms family  come 1st follwed by getting blessing from bride parents)\n\n4. Seetha kalyana song 23:16 to 28:50, please make it completely instrumental no lyrics, if not possible please let us know\n Bakyia lakshmi song 28:50 to 30:00, please make it completely instrumental no lyrics, if not possible please let us know	incoming	2025-06-12 23:23:46	b251c6bc-1c0c-45cd-b0b6-3060832b29c5	\N	\N	f	2025-06-13 04:53:48.233	2025-06-13 04:53:48.233
6	\N	919884261872	Instrumental music means no lyrics at all	incoming	2025-06-12 23:24:08	fce7b9d0-30ea-42f1-a3c6-97c8908f8679	\N	\N	f	2025-06-13 04:54:08.909	2025-06-13 04:54:08.909
9	\N	918888888888	Hello, I'm interested in wedding photography	incoming	2025-06-13 04:55:20	test_live_001	\N	\N	f	2025-06-13 04:55:20.483	2025-06-13 04:55:20.483
38	1	9677362524	Tell me about my package and amount	incoming	2025-01-13 05:28:00	test_msg_127	\N	\N	t	2025-06-13 05:32:38.796	2025-06-13 05:32:38.796
37	1	9677362524	Your quotation QT-2025-0001 status is pending_approval.	outgoing	2025-06-13 05:30:18.544	\N	\N	\N	t	2025-06-13 05:30:18.547	2025-06-13 05:30:18.547
31	1	9677362524	Tell me my quotation details	incoming	2025-01-13 05:20:00	test_msg_123	\N	\N	t	2025-06-13 05:27:56.637	2025-06-13 05:27:56.637
25	1	919677362524	What is my exact quotation amount and package details?	incoming	2025-01-29 08:30:00	test_comprehensive_001	\N	\N	t	2025-06-13 05:17:05.545	2025-06-13 05:17:05.545
15	1	919677362524	Yes, I got it. Candid photography captures natural moments without posing. Your test noted.	outgoing	2025-06-13 05:03:25.336	outgoing_1749810805332	\N	\N	t	2025-06-13 05:03:25.337	2025-06-13 05:03:25.337
14	1	919677362524	Testing quotation mapping with improved phone matching	incoming	2025-01-29 06:35:00	test_mapping_002	\N	\N	t	2025-06-13 05:03:20.074	2025-06-13 05:03:20.074
13	1	919677362524	Candid photography captures natural moments without posing. You got it?	outgoing	2025-06-13 05:02:13.295	outgoing_1749810733287	\N	\N	t	2025-06-13 05:02:13.295	2025-06-13 05:02:13.295
16	\N	917904348108	Hello hi	incoming	2025-06-12 23:38:09	aee8d63f-fc86-4bd7-98d6-4325af020c2b	\N	\N	f	2025-06-13 05:08:11.595	2025-06-13 05:08:11.595
11	1	919677362524	Portfolio: https://www.ooak.photography | Instagram: @ooak.photography	outgoing	2025-06-13 05:00:26.465	outgoing_1749810626462	\N	\N	t	2025-06-13 05:00:26.466	2025-06-13 05:00:26.466
8	1	919677362524	Portfolio: https://www.ooak.photography | Instagram: @ooak.photography	outgoing	2025-06-13 04:55:17.226	outgoing_1749810317219	\N	\N	t	2025-06-13 04:55:17.23	2025-06-13 04:55:17.23
7	1	919677362524	Hi OOAK! I need photography for my wedding. Can you share pricing?	incoming	2025-06-13 04:55:15	test_incoming_001	\N	\N	t	2025-06-13 04:55:15.834	2025-06-13 04:55:15.834
34	1	9677362524	What are bride and groom names?	incoming	2025-01-13 05:26:00	test_msg_125	\N	\N	t	2025-06-13 05:29:46.604	2025-06-13 05:29:46.604
41	\N	917032180673	.	incoming	2025-06-16 02:34:15	0792a55f-bc7a-4133-a7c1-0ddd1744cb08	\N	\N	f	2025-06-16 08:04:15.65	2025-06-16 08:04:15.65
44	\N	917032180673	None	incoming	2025-06-16 02:55:36	c61e4e80-135a-4954-93bd-c14da7ab968f	\N	\N	f	2025-06-16 08:25:40.657	2025-06-16 08:25:40.657
47	\N	918008895327	Check out my portfolio	incoming	2025-06-16 02:59:00	3a8cf34a-e504-49fb-90cc-e6f5345331e5	\N	\N	f	2025-06-16 08:29:01.508	2025-06-16 08:29:01.508
50	\N	917032180673	None	incoming	2025-06-16 17:15:03	80e21117-1a44-44a1-9252-4e42f7ba7aca	\N	\N	f	2025-06-16 22:45:06.539	2025-06-16 22:45:06.539
53	\N	919626308646	Yes	incoming	2025-06-16 17:24:54	daf242c9-987c-4939-a435-24b00fd4da18	\N	\N	f	2025-06-16 22:54:56.494	2025-06-16 22:54:56.494
56	\N	917032180673	Noted, thank you	incoming	2025-06-16 17:33:05	fcbbc1e6-1d3c-4aaa-aaa4-073fc7b7e3a3	\N	\N	f	2025-06-16 23:03:06.199	2025-06-16 23:03:06.199
59	\N	919652279284	Hello. \nWe are okay with traditional video	incoming	2025-06-16 18:23:19	2d754ec6-9ab0-42d0-bb98-a80e7d88f2c0	\N	\N	f	2025-06-16 23:53:21.053	2025-06-16 23:53:21.053
62	\N	919652279284	Yeah	incoming	2025-06-16 18:38:07	5df603aa-13b1-46f5-b677-300ad6e7a580	\N	\N	f	2025-06-17 00:08:08.392	2025-06-17 00:08:08.392
65	\N	917032180673	By this Friday will complete the selection	incoming	2025-06-16 19:06:42	ffbb1713-69ce-4193-8b03-cd16e18fa4a7	\N	\N	f	2025-06-17 00:36:44.199	2025-06-17 00:36:44.199
2	1	919677362524	Do you have my quotation ?	incoming	2025-06-12 23:16:13	635e5199-d9e2-48a3-b80a-7989b9a74b39	\N	\N	t	2025-06-13 04:46:14.409	2025-06-13 04:46:14.409
1	1	919677362524	Thanks	incoming	2025-06-12 23:13:21	b433ed57-f031-4189-9c67-a3ca00892428	\N	\N	t	2025-06-13 04:43:22.362	2025-06-13 04:43:22.362
12	1	919677362524	Testing improved quotation mapping system	incoming	2025-01-29 06:30:00	test_mapping_001	\N	\N	t	2025-06-13 05:02:08.075	2025-06-13 05:02:08.075
4	1	919677362524	Hi OOAK! Testing the AI system	incoming	2025-01-29 04:30:00	test_allowed	\N	\N	t	2025-06-13 04:47:30.024	2025-06-13 04:47:30.024
17	1	919677362524	Hi Vikas! Do you remember my wedding details? When is my event?	incoming	2025-01-29 07:30:00	test_context_001	\N	\N	t	2025-06-13 05:11:16.125	2025-06-13 05:11:16.125
18	1	919677362524	Yes, your wedding is on June 24th. Confirmed.	outgoing	2025-06-13 05:11:22.716	outgoing_1749811282707	\N	\N	t	2025-06-13 05:11:22.717	2025-06-13 05:11:22.717
19	1	919677362524	What package did we discuss? And whats the total amount?	incoming	2025-01-29 07:35:00	test_context_002	\N	\N	t	2025-06-13 05:11:50.587	2025-06-13 05:11:50.587
20	1	919677362524	Yes. Essential ₹75k, Premium ₹1.25L, Luxury ₹2L. Which interests you?	outgoing	2025-06-13 05:11:51.902	outgoing_1749811311895	\N	\N	t	2025-06-13 05:11:51.904	2025-06-13 05:11:51.904
21	1	919677362524	What is my total quotation amount for the elite package?	incoming	2025-01-29 07:40:00	test_context_003	\N	\N	t	2025-06-13 05:12:54.047	2025-06-13 05:12:54.047
22	1	919677362524	Yes. Essential ₹75k, Premium ₹1.25L, Luxury ₹2L. Which interests you?	outgoing	2025-06-13 05:12:54.886	outgoing_1749811374878	\N	\N	t	2025-06-13 05:12:54.887	2025-06-13 05:12:54.887
39	1	9677362524	Your Elite package quotation QT-2025-0001 is ₹245,000. Still pending approval.	outgoing	2025-06-13 05:32:41.142	\N	\N	\N	t	2025-06-13 05:32:41.145	2025-06-13 05:32:41.145
32	1	9677362524	What is my quotation number?	incoming	2025-01-13 05:25:00	test_msg_124	\N	\N	t	2025-06-13 05:29:20.941	2025-06-13 05:29:20.941
35	1	9677362524	Bride is Ramya and groom is Noble.	outgoing	2025-06-13 05:29:48.372	\N	\N	\N	t	2025-06-13 05:29:48.372	2025-06-13 05:29:48.372
42	\N	917032180673	Can you please confirm on this and size of the frame	incoming	2025-06-16 02:34:29	2a53dd6d-fd67-487f-a14b-e42f0a234410	\N	\N	f	2025-06-16 08:04:29.726	2025-06-16 08:04:29.726
45	\N	918008895327	Hi	incoming	2025-06-16 02:58:30	9a10b1c8-7730-4969-ae6c-552345432d72	\N	\N	f	2025-06-16 08:28:33.976	2025-06-16 08:28:33.976
48	\N	918008895327	If there is any Requirement pls let me know	incoming	2025-06-16 02:59:07	f0352e0f-ceaa-4d70-823a-ff01cb28b3fe	\N	\N	f	2025-06-16 08:29:07.914	2025-06-16 08:29:07.914
51	\N	918553925800	Please call Nikitha for this	incoming	2025-06-16 17:17:21	5bc11e0e-8b4c-4aa1-b61d-022dcc9ac782	\N	\N	f	2025-06-16 22:47:22.113	2025-06-16 22:47:22.113
54	\N	919626308646	Add couple clips	incoming	2025-06-16 17:25:09	04531c90-8d60-41f4-99d1-175385e7af1d	\N	\N	f	2025-06-16 22:55:09.3	2025-06-16 22:55:09.3
57	\N	918748065227	Ok	incoming	2025-06-16 18:09:21	c58b0596-2738-4925-a8b1-37dd2e696690	\N	\N	f	2025-06-16 23:39:22.722	2025-06-16 23:39:22.722
60	\N	919652279284	When can we expect hybrid video ?	incoming	2025-06-16 18:23:53	24b12cdc-3922-4005-ba68-2fdb5df9d1c6	\N	\N	f	2025-06-16 23:53:54.943	2025-06-16 23:53:54.943
63	\N	919652279284	We got it	incoming	2025-06-16 18:38:12	acfe72fd-b528-4a1b-9a0f-8b91fd2fa6b8	\N	\N	f	2025-06-17 00:08:12.308	2025-06-17 00:08:12.308
10	1	919677362524	What’s is candid photography means ?	incoming	2025-06-12 23:30:23	c3207646-3eca-43a7-a3ae-1aa129473d99	\N	\N	t	2025-06-13 05:00:24.44	2025-06-13 05:00:24.44
27	1	919677362524	What did we discuss in our previous conversations about photography?	incoming	2025-01-29 08:35:00	test_comprehensive_002	\N	\N	t	2025-06-13 05:17:38.744	2025-06-13 05:17:38.744
23	1	919677362524	Hi! Can you show me your portfolio?	incoming	2025-01-29 07:45:00	test_working_001	\N	\N	t	2025-06-13 05:13:29.549	2025-06-13 05:13:29.549
24	1	919677362524	Portfolio: https://www.ooak.photography | Instagram: @ooak.photography	outgoing	2025-06-13 05:13:32.246	outgoing_1749811412239	\N	\N	t	2025-06-13 05:13:32.248	2025-06-13 05:13:32.248
26	1	919677362524	Your Elite package quotation #1 is ₹245,000. Status: approved.	outgoing	2025-06-13 05:17:09.738	outgoing_1749811629732	\N	\N	t	2025-06-13 05:17:09.739	2025-06-13 05:17:09.739
28	1	919677362524	We discussed candid photography and your portfolio questions.	outgoing	2025-06-13 05:17:42.15	outgoing_1749811662144	\N	\N	t	2025-06-13 05:17:42.152	2025-06-13 05:17:42.152
29	1	919677362524	Who is the bride and groom in my quotation and what is the workflow status?	incoming	2025-01-29 08:40:00	test_comprehensive_003	\N	\N	t	2025-06-13 05:18:04.411	2025-06-13 05:18:04.411
30	1	919677362524	Bride: Ramya | Workflow Status: pending_approval	outgoing	2025-06-13 05:18:08.527	outgoing_1749811688520	\N	\N	t	2025-06-13 05:18:08.528	2025-06-13 05:18:08.528
33	1	9677362524	Your quotation number is QT-2025-0001.	outgoing	2025-06-13 05:29:23.567	\N	\N	\N	t	2025-06-13 05:29:23.57	2025-06-13 05:29:23.57
36	1	9677362524	What is my quotation status?	incoming	2025-01-13 05:27:00	test_msg_126	\N	\N	t	2025-06-13 05:30:16.522	2025-06-13 05:30:16.522
40	\N	917032180673	Hi Durga, not yet due to emergency couldn’t finish the selection \n\nWill notify once it is done	incoming	2025-06-16 02:34:05	2ea28e57-94ed-4cff-9c62-39b9df031df2	\N	\N	f	2025-06-16 08:04:07.487	2025-06-16 08:04:07.487
43	\N	917032180673	Traditional Video looks good,\n\nI need clarification regarding the photo frame did it got printed or can we change the picture\n\nAnd what size frame will be given	incoming	2025-06-16 02:40:38	2e746354-ae4e-4f1a-81ef-4abd30bc66a6	\N	\N	f	2025-06-16 08:10:39.741	2025-06-16 08:10:39.741
46	\N	918008895327	This is Joseph freelance candid photographer	incoming	2025-06-16 02:58:35	9ffc7440-f891-439c-93fc-d1fbe7cf1d3e	\N	\N	f	2025-06-16 08:28:36.36	2025-06-16 08:28:36.36
49	\N	917032180673	Thank you.\n\nNeed one confirmation regarding editing my sister in the above picture \n\nFor album and the frame \n\nI will share the pic. Please check with your team and let me know	incoming	2025-06-16 17:14:40	8e44dae3-510d-4264-9b4c-8cfe3aca2235	\N	\N	f	2025-06-16 22:44:43.697	2025-06-16 22:44:43.697
52	\N	919626308646	3.48- 4.15	incoming	2025-06-16 17:22:05	7a2e0669-e375-45a9-8a61-2892f4b4ede2	\N	\N	f	2025-06-16 22:52:06.804	2025-06-16 22:52:06.804
55	\N	917358592603	Nachde ne saare - from Baar baar dekho \nOr kabira (encore ) - from Yeh Jawaani hai Deewani	incoming	2025-06-16 17:27:26	8bce2956-8260-441c-8811-2b7206a276b4	\N	\N	f	2025-06-16 22:57:26.647	2025-06-16 22:57:26.647
58	\N	917032180673	Okay	incoming	2025-06-16 18:15:47	2d46f7a4-7495-414b-983b-5f8a20d66248	\N	\N	f	2025-06-16 23:45:49.21	2025-06-16 23:45:49.21
61	\N	919652279284	Okay	incoming	2025-06-16 18:32:56	ee2ef543-216f-4409-84b2-43d714f07ba1	\N	\N	f	2025-06-17 00:02:57.368	2025-06-17 00:02:57.368
64	\N	919229303189	I need job sir..	incoming	2025-06-16 19:01:59	45e9a69a-f89e-44a8-bbf1-ed0a9cfa6ba6	\N	\N	f	2025-06-17 00:32:01.496	2025-06-17 00:32:01.496
66	\N	919182912008	my parents are looking on that	incoming	2025-06-17 23:21:27	84858ef1-6da1-4113-a4f1-39f54a7a78a0	\N	\N	f	2025-06-18 04:51:31.958	2025-06-18 04:51:31.958
71	\N	919677362524	WhatsApp table verified successfully! Ready for real-time testing with PostgreSQL and existing business schema.	incoming	2025-06-19 01:23:28.826	setup_test_1750316008838	\N	\N	f	2025-06-19 01:23:28.826	2025-06-19 01:23:28.826
\.


--
-- Data for Name: whatsapp_templates; Type: TABLE DATA; Schema: public; Owner: vikasalagarsamy
--

COPY public.whatsapp_templates (id, template_name, template_type, template_content, variables, language_code, status, ai_optimized, created_at, updated_at) FROM stdin;
\.


--
-- Name: accounting_workflows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.accounting_workflows_id_seq', 1, false);


--
-- Name: action_recommendations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.action_recommendations_id_seq', 1, false);


--
-- Name: ai_behavior_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.ai_behavior_settings_id_seq', 1, false);


--
-- Name: ai_communication_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.ai_communication_tasks_id_seq', 22, true);


--
-- Name: ai_configurations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.ai_configurations_id_seq', 3, true);


--
-- Name: ai_prompt_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.ai_prompt_templates_id_seq', 1, false);


--
-- Name: ai_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.ai_tasks_id_seq', 148, true);


--
-- Name: branches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.branches_id_seq', 7, true);


--
-- Name: business_trends_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.business_trends_id_seq', 1, false);


--
-- Name: call_triggers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.call_triggers_id_seq', 28, true);


--
-- Name: client_communication_timeline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.client_communication_timeline_id_seq', 71, true);


--
-- Name: client_insights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.client_insights_id_seq', 1, false);


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.clients_id_seq', 1, false);


--
-- Name: communications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.communications_id_seq', 4, true);


--
-- Name: companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.companies_id_seq', 6, true);


--
-- Name: conversation_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.conversation_sessions_id_seq', 81, true);


--
-- Name: deliverable_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.deliverable_master_id_seq', 1, false);


--
-- Name: deliverables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.deliverables_id_seq', 14, true);


--
-- Name: department_instructions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.department_instructions_id_seq', 1, false);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.departments_id_seq', 22, true);


--
-- Name: designation_menu_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.designation_menu_permissions_id_seq', 1459, true);


--
-- Name: designations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.designations_id_seq', 38, true);


--
-- Name: dynamic_menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.dynamic_menus_id_seq', 77, true);


--
-- Name: employee_companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.employee_companies_id_seq', 45, true);


--
-- Name: employee_devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.employee_devices_id_seq', 67, true);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.employees_id_seq', 50, true);


--
-- Name: instagram_analytics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.instagram_analytics_id_seq', 1, true);


--
-- Name: instagram_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.instagram_comments_id_seq', 4, true);


--
-- Name: instagram_interactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.instagram_interactions_id_seq', 2, true);


--
-- Name: instagram_mentions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.instagram_mentions_id_seq', 2, true);


--
-- Name: instagram_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.instagram_messages_id_seq', 3, true);


--
-- Name: instagram_story_mentions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.instagram_story_mentions_id_seq', 2, true);


--
-- Name: instruction_approvals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.instruction_approvals_id_seq', 1, false);


--
-- Name: lead_drafts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.lead_drafts_id_seq', 1, false);


--
-- Name: lead_followups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.lead_followups_id_seq', 1, false);


--
-- Name: lead_sources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.lead_sources_id_seq', 1, true);


--
-- Name: lead_task_performance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.lead_task_performance_id_seq', 1, false);


--
-- Name: leads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.leads_id_seq', 29, true);


--
-- Name: management_insights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.management_insights_id_seq', 24, true);


--
-- Name: menu_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.menu_items_id_seq', 80, true);


--
-- Name: menu_items_tracking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.menu_items_tracking_id_seq', 1, false);


--
-- Name: message_analysis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.message_analysis_id_seq', 1, false);


--
-- Name: ml_model_performance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.ml_model_performance_id_seq', 1, false);


--
-- Name: notification_batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.notification_batches_id_seq', 1, false);


--
-- Name: partners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.partners_id_seq', 1, false);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.payments_id_seq', 2, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.permissions_id_seq', 1, false);


--
-- Name: post_sale_confirmations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.post_sale_confirmations_id_seq', 1, false);


--
-- Name: post_sales_workflows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.post_sales_workflows_id_seq', 1, false);


--
-- Name: query_performance_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.query_performance_logs_id_seq', 1, false);


--
-- Name: quotation_approvals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.quotation_approvals_id_seq', 50, true);


--
-- Name: quotation_business_lifecycle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.quotation_business_lifecycle_id_seq', 26, true);


--
-- Name: quotation_edit_approvals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.quotation_edit_approvals_id_seq', 1, false);


--
-- Name: quotation_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.quotation_events_id_seq', 33, true);


--
-- Name: quotation_predictions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.quotation_predictions_id_seq', 1, false);


--
-- Name: quotation_revisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.quotation_revisions_id_seq', 1, false);


--
-- Name: quotation_workflow_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.quotation_workflow_history_id_seq', 1, false);


--
-- Name: quotations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.quotations_id_seq', 5, true);


--
-- Name: quote_components_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.quote_components_id_seq', 1, false);


--
-- Name: quote_deliverables_snapshot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.quote_deliverables_snapshot_id_seq', 1, false);


--
-- Name: quote_services_snapshot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.quote_services_snapshot_id_seq', 1, false);


--
-- Name: revenue_forecasts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.revenue_forecasts_id_seq', 1, false);


--
-- Name: role_menu_access_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.role_menu_access_id_seq', 196, true);


--
-- Name: role_menu_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.role_menu_permissions_id_seq', 9729, true);


--
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.role_permissions_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.roles_id_seq', 8, true);


--
-- Name: sales_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.sales_activities_id_seq', 1, false);


--
-- Name: sales_performance_metrics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.sales_performance_metrics_id_seq', 1, false);


--
-- Name: sales_team_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.sales_team_members_id_seq', 1, false);


--
-- Name: sequence_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.sequence_rules_id_seq', 1, false);


--
-- Name: sequence_steps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.sequence_steps_id_seq', 1, false);


--
-- Name: service_packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.service_packages_id_seq', 1, false);


--
-- Name: services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.services_id_seq', 11, true);


--
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 1, false);


--
-- Name: system_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.system_logs_id_seq', 1, false);


--
-- Name: task_generation_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.task_generation_log_id_seq', 1, false);


--
-- Name: task_performance_metrics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.task_performance_metrics_id_seq', 1, false);


--
-- Name: task_sequence_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.task_sequence_templates_id_seq', 4, true);


--
-- Name: task_status_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.task_status_history_id_seq', 1, false);


--
-- Name: team_performance_trends_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.team_performance_trends_id_seq', 1, false);


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.teams_id_seq', 1, false);


--
-- Name: unified_role_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.unified_role_permissions_id_seq', 1, false);


--
-- Name: user_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.user_accounts_id_seq', 8, true);


--
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.user_roles_id_seq', 1, false);


--
-- Name: vendors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.vendors_id_seq', 1, false);


--
-- Name: whatsapp_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vikasalagarsamy
--

SELECT pg_catalog.setval('public.whatsapp_messages_id_seq', 71, true);


--
-- Name: designation_menu_permissions designation_menu_permissions_designation_id_menu_item_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_designation_id_menu_item_id_key UNIQUE (designation_id, menu_item_id);


--
-- Name: designation_menu_permissions designation_menu_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_pkey PRIMARY KEY (id);


--
-- Name: designations designations_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_pkey PRIMARY KEY (id);


--
-- Name: employees employees_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_employee_id_key UNIQUE (employee_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: designation_menu_permissions designation_menu_permissions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.employees(employee_id);


--
-- Name: designation_menu_permissions designation_menu_permissions_designation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_designation_id_fkey FOREIGN KEY (designation_id) REFERENCES public.designations(id) ON DELETE CASCADE;


--
-- Name: designation_menu_permissions designation_menu_permissions_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id) ON DELETE CASCADE;


--
-- Name: designation_menu_permissions designation_menu_permissions_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.employees(employee_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: vikasalagarsamy
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

